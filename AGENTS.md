# AGENTS.md

- Repo type: Nix flake dotfiles / machine config.
- Root flake outputs: `nixosConfigurations.{lab,nixbox,nixtop,snowball}` and `darwinConfigurations.workbook`.
- Use `nix flake show` / `nix eval .#...` to inspect outputs; there is no repo-local task runner or CI config in this tree.
- Format Nix with `nixfmt` or `nixpkgs-fmt`; both are included in the Home Manager package set.
- Home Manager config is split by role in `profiles.nix`; Linux and work profiles import the shared `liam` module stack, and `home-manager/modules/nvim` is a symlink to the out-of-tree `config/` directory.
- `home-manager/default.nix` only enables shared env/programs for roles `dev` or `work`.
- `home-manager/modules/git.nix` sets Git identity and signing; keep those values consistent with the profile in use.
- `home-manager/modules/zsh.nix` defines useful shell aliases, including `hms = home-manager switch`.
- NixOS hosts under `hosts/` are the machine-specific entrypoints; shared Linux behavior lives under `modules/linux/`.
- `hosts/lab/configuration.nix` is service-heavy and includes Zigbee2MQTT, Mosquitto, Homepage, Incus, and libvirt; treat it as an operational host config, not a template.
- Secrets use `sops-nix`; `secrets/default.nix` expects `/var/lib/sops-nix/keys.txt`, and Linux profiles also wire `sops.age.sshKeyPaths` from the host SSH key.
- `modules/linux/hardware/nixos-laptop.nix` is generated and should not be edited directly.
- `Makefile` only contains `vm/secrets`, which rsyncs `~/.gnupg` and `~/.ssh` to the VM.
