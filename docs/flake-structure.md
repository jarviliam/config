# Nix flake structure and flow

This repository is a **machine configuration / dotfiles flake**. It defines a small set of device targets and then composes them from shared profiles, shared modules, and per-host overrides.

## Top-level shape

The important entry points are:

- `flake.nix` — declares inputs and publishes outputs.
- `lib.nix` — helper functions, especially `createSystem`.
- `profiles.nix` — shared profiles for each type of machine/user.
- `hosts/` — host-specific NixOS entrypoints.
- `modules/` — shared system modules for Linux and Darwin.
- `home-manager/` — shared user configuration and application setup.
- `secrets/` — SOPS-backed secret wiring.
- `pkgs/` — custom package definitions and overlay imports.

## Flake outputs

`flake.nix` exposes four main output groups:

- `packages` — packages exported from the flake overlay.
- `overlays.default` — the package overlay used by the configs.
- `nixosConfigurations` — Linux machine definitions.
- `darwinConfigurations` — macOS machine definitions.

The current device targets are:

- `nixosConfigurations.nixtop`
- `nixosConfigurations.nixbox`
- `nixosConfigurations.snowball`
- `nixosConfigurations.lab`
- `darwinConfigurations.workbook`

## The composition model

The repo is built in layers:

1. **`flake.nix`** selects a profile and a list of modules.
2. **`profiles.nix`** expands that into shared system config and shared Home Manager config.
3. **`lib.createSystem`** merges the profile, the call-site modules, and the host-specific modules.
4. **NixOS or nix-darwin** evaluates the final module graph.
5. **Home Manager** is embedded into the system config for user-level programs and dotfiles.

In practice, the flow is:

```text
flake.nix
  -> profiles.nix
    -> lib.createSystem
      -> nixosSystem or darwinSystem
        -> host modules + shared modules
        -> embedded Home Manager modules
```

## `lib.createSystem`

`lib.nix` contains the key orchestration function:

- picks `nixosSystem` for Linux and `darwinSystem` for macOS
- embeds Home Manager when enabled by the profile
- passes shared `specialArgs` into modules
- makes the overlay available to the system

The merge order matters:

- call-site `modules` are added first
- profile `modules` are appended after them
- Home Manager imports are assembled separately, with profile HM modules first and call-site HM modules after them

That means **profile config is the common baseline**, while the host-specific files can override it.

## Profiles

`profiles.nix` defines four reusable setups:

### `liam`

Shared baseline for the main user:

- user name: `liam.jarvis`
- adds `./secrets/default.nix`
- adds `./modules/nix.nix`
- enables Home Manager
- loads shared Home Manager modules:
  - `home-manager/default.nix`
  - `home-manager/packages.nix`
  - `home-manager/modules/git.nix`
  - `home-manager/modules/zsh.nix`
  - `home-manager/modules/bat.nix`
  - `home-manager/modules/fzf.nix`
  - `home-manager/modules/bitwarden.nix`
  - `home-manager/modules/nvim`
  - `home-manager/modules/ghostty.nix`
  - `home-manager/modules/nix-index.nix`
  - `sops-nix` Home Manager module

It also sets shared `roles` and common `specialArgs` such as `flakePath` and `homeDirectory`.

### `liam-linux`

Linux-specific extension of `liam`:

- changes the username to `liam`
- adds Linux-only system modules:
  - `hosts/modules/common.nix`
  - `modules/linux/network.nix`
  - `modules/linux/window.nix`
  - `sops-nix` system module
- adds Linux-only Home Manager modules:
  - `home-manager/modules/firefox`
  - `home-manager/modules/hyprland.nix`
- sets Linux roles to `dev` + `graphical`

### `liam-work`

Darwin/work profile:

- keeps the macOS username `liam.jarvis`
- adds `./modules/darwin`
- sets roles to `dev` + `work`
- uses the macOS home path `/Users/liam.jarvis`

### `lab`

Server/admin profile:

- username `admin`
- adds SOPS system secrets
- does **not** enable the full shared Home Manager stack

### `vm`

Virtual-machine style profile:

- username `liam`
- reuses the shared Linux Home Manager stack
- sets roles to `dev` + `work`

## Host directories

Each host directory is the place for machine-specific NixOS configuration.

### `hosts/nixbox/`

Desktop machine with host-specific hardware, QMK keyboard support, NVIDIA settings, and a Hyprland import.

### `hosts/snowball/`

More minimal NixOS machine. It sets the hostname, user, SSH access, Docker/Incus/Tailscale, and a smaller package set.

### `hosts/lab/`

Operational home server. It includes:

- Zigbee2MQTT
- Mosquitto
- Homepage dashboard
- Incus and libvirt
- a bridged network setup
- service modules under `hosts/lab/modules/`

### `hosts/modules/`

Shared Linux host modules:

- `common.nix` — broad desktop utilities and Nix settings
- `hyprland.nix` — host-side Hyprland integration

## Shared system modules

### `modules/linux/system.nix`

Base Linux system behavior:

- packages like `vim`, `git`, `wget`, `xclip`, `sbctl`, `kitty`
- bootloader setup
- graphics and PipeWire
- locale/timezone
- user account creation and groups

### `modules/linux/network.nix`

NetworkManager + systemd-resolved + SSH defaults.

### `modules/linux/window.nix`

Desktop display/login configuration for Hyprland-based sessions.

### `modules/darwin/default.nix`

macOS system defaults:

- Homebrew
- Touch ID sudo
- user shell / keyboard mapping
- trusted users for Nix

### `modules/darwin/yabai/` and `modules/darwin/skhd/`

Window management on macOS:

- `yabai` handles tiling/window rules
- `skhd` binds keyboard shortcuts to `yabai`

## Home Manager layer

Home Manager is where the user-facing environment is assembled.

### `home-manager/default.nix`

Enables baseline user tooling when the profile has role `dev` or `work`:

- `EDITOR=nvim`
- `PAGER=bat`
- `direnv`
- `gpg`
- `btop`
- `gpg-agent` SSH support

It also optionally imports the AI-related HM modules when those roles are present.

### `home-manager/packages.nix`

Defines the large shared package set for the user environment:

- dev tools
- language toolchains
- CLI helpers
- OS-specific packages for Linux vs Darwin

### `home-manager/modules/*`

These are focused feature modules:

- `git.nix` — Git identity, signing, aliases
- `zsh.nix` — shell config, prompts, completions, aliases
- `bat.nix` / `fzf.nix` / `ghostty.nix` / `bitwarden.nix` / `nix-index.nix`
- `firefox/` — browser config for Linux
- `nvim/` — symlink to the out-of-tree editor config

### AI tooling

`home-manager/modules/ai/` wires in agent-related tooling:

- `skills/default.nix` enables selected skills from the `mattpocock-skills` flake input
- `opencode.nix` configures opencode and MCP/LSP integrations
- `pi.nix` adds Raspberry Pi-specific AI support pieces

## Secrets flow

Secrets are handled by `sops-nix`:

- `secrets/default.nix` installs `sops`, `age`, and `ssh-to-age`
- it points system configs at `/var/lib/sops-nix/keys.txt`
- Linux Home Manager also uses `config.xdg.configHome}/sops/age/keys.txt`
- host-specific secret files live in `secrets/shared.yaml`

## Package overlay flow

`flake.nix` imports `./pkgs/import.nix` as the default overlay.

That overlay is used in two ways:

- exposed as `overlays.default`
- installed into profiles via `nixpkgs.overlays = [ self.overlays.default ]`

This is how custom packages like `gitspice`, `zmx`, `release-please`, `tailscale-acl-combiner`, and others become available throughout the config.

## Typical evaluation path for a device

When you build a machine target, Nix evaluates roughly this chain:

1. choose the target from `flake.nix`
2. load the matching profile from `profiles.nix`
3. merge host modules and shared system modules
4. embed the relevant Home Manager imports
5. apply the overlay and shared package set
6. resolve secrets and host-specific settings

So, for example:

- `nixosConfigurations.nixbox` = `profiles.liam-linux` + `hosts/nixbox/configuration.nix` + `modules/linux/system.nix`
- `nixosConfigurations.lab` = `profiles.lab` + `hosts/lab/configuration.nix`
- `darwinConfigurations.workbook` = `profiles.liam-work` + `modules/darwin/default.nix`

## Mental model

Think of the repo as three concentric rings:

1. **Shared baseline** — user defaults, package overlay, secrets, shell/editor tools
2. **Platform layer** — Linux vs Darwin behaviors
3. **Machine layer** — host-specific hardware, services, and networking

That keeps most configuration reusable while letting each device diverge where it needs to.
