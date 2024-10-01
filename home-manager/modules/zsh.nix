{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = false;
    defaultKeymap = "viins";
    historySubstringSearch.enable = true;
    # Hack because /etc/static isn't in $NIX_PROFILE
    # initExtraBeforeCompInit = ''
    #   fpath+=(/etc/static/profiles/per-user/liam.jarvis/share/zsh/site-functions /etc/static/profiles/per-user/liam.jarvis/share/zsh/$ZSH_VERSION/functions /etc/static/profiles/per-user/liam.jarvis/share/zsh/vendor-completions )
    # '';
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true; # ignore commands starting with a space
      save = 10000;
      size = 10000;
      share = true;
    };
    shellAliases = {
      nv = "nvim";
      # builtins
      size = "du -sh";
      cp = "cp -i";
      mkdir = "mkdir -p";
      df = "df -h";
      free = "free -h";
      du = "du -sh";
      op = "xdg-open";
      del = "rm -rf";
      sdel = "sudo rm -rf";
      lst = "ls --tree -I .git";
      lsl = "ls -l";
      lsa = "ls -a";

      python = "python3";
      pip = "python3 -m pip";
      venv = "python3 -m venv";

      kc = "kubectl";
      kca = "kubectl apply -f";
      ku = "kubie";
      dk = "docker";
      dc = "docker-compose";
      pd = "podman";
      pc = "podman-compose";
      li = "lima nerdctl";
      lc = "limactl";
      poe = "poetry";

      ca = "cargo";
      tf = "terraform";
      diff = "delta";
      nr = "npm run";
      py = "python";
      psf = "ps -aux | grep";

      # nix
      ne = "nvim -c ':cd ~/.nixpkgs' ~/.nixpkgs";
      clean = "nix-collect-garbage -d && nix-store --gc && nix-store --verify --check-contents --repair";
      nsh = "nix-shell";
      nse = "nix search nixpkgs";

      nixd = "nix store gc --debug";
      nix7 = "nix profile wipe-history --older-than 7d";
      nixu = "nix flake update";
      nixi = "nix profile install";
      nixr = "nix profile remove";
      nixl = "nix profile list";
      hms = "home-manager switch";
      hmg = "home-manager";
      hmd7 = "home-manager expire-generations '-7 days'";
      hml = "home-manager generations";
      hmr = "home-manager remove-generations";
    };
    initExtra = ''
      zstyle ':fzf-tab:complete:_zlua:*' query-string input
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' switch-group ',' '.'
      zstyle ':completion:*:git-checkout:*' sort false
      export PATH="/opt/homebrew/bin:$PATH"
    '';
    #
    # initExtra = ''
    #   alias my-opened-prs='gh pr list --search "is:open author:@me updated:$(date +"%Y-%m-%d")" --json number,title | jq -r ".[] | \"\(.number),\(.title)\"" | pbcopy'
    #   alias my-merged-prs='gh pr list --search "is:merged author:@me updated:$(date +"%Y-%m-%d")" --json number,title | jq -r ".[] | \"\(.number),\(.title)\"" | pbcopy'
    #   eval "$(luarocks path --bin)"
    # '';
    antidote = {
      enable = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
        "Aloxaf/fzf-tab"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zsh-users/zsh-completions kind:fpath"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-history-substring-search kind:defer"
        "MichaelAquilina/zsh-you-should-use kind:defer"
        "chisui/zsh-nix-shell"
        "wfxr/forgit"
        "getantidote/use-omz" # handle OMZ dependencies
        "ohmyzsh/ohmyzsh path:lib" # load OMZ's library
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages kind:defer" # load OMZ plugins
        "ohmyzsh/ohmyzsh path:plugins/fancy-ctrl-z kind:defer"
      ];
    };
    sessionVariables = {
      HOMEBREW_NO_ANALYTICS = 1;
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship =
    let
      flavour = "frappe";
    in
    {
      enable = true;
      enableZshIntegration = true;
      settings =
        {
          palette = "catppuccin_${flavour}";
          add_newline = false;
          format = lib.concatStrings [
            "$python"
            "$directory"
            "$character"
          ];
          right_format = "$status$all";
          aws = {
            disabled = true;
          };
          character = {
            success_symbol = "[❯](red)[❯](yellow)[❯](green)";
            error_symbol = "[❯](red)[❯](yellow)[❯](green)";
            vicmd_symbol = "[❮](green)[❮](yellow)[❮](red)";
          };
          c = {
            symbol = " ";
            format = "\\[[$symbol($version(-$name))]($style)\\]";
          };
          cmake = {
            format = "\\[[$symbol($version)]($style)\\]";
          };
          cmd_duration = {
            format = "\\[[$duration]($style)\\]";
          };
          directory = {
            style = "blue";
            truncation_length = 1;
            truncation_symbol = "";
            fish_style_pwd_dir_length = 1;
          };
          line_break = {
            disabled = true;
          };
          git_state = {
            format = "[[$state($progress_current/$progress_total)] ]($style)";
            style = "fg:peach";
            disabled = false;
          };
          git_branch = {
            format = "[$branch]($style) ";
            style = "bold green";
          };
          status = {
            disabled = false;
            symbol = "✘ ";
          };
          git_status = {
            format = "$all_status$ahead_behind ";
            ahead = "[⬆](bold purple) ";
            behind = "[⬇](bold purple) ";
            staged = "[✚](green) ";
            deleted = "[✖](red) ";
            renamed = "[➜](purple) ";
            stashed = "[✭](cyan) ";
            untracked = "[◼](white) ";
            modified = "[✱](blue) ";
            conflicted = "[═](yellow) ";
            diverged = "⇕ ";
            up_to_date = "";
          };
          git_commit = {
            format = "[$tag ]($style)";
            style = "fg:peach";
            tag_disabled = false;
            tag_symbol = " ";
          };
          golang = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          haskell = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          helm = {
            format = "\\[[$symbol($version)]($style)\\]";
          };
          hg_branch = {
            symbol = " ";
            format = "\\[[$symbol$branch]($style)\\]";
          };
          java = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          kotlin = {
            format = "\\[[$symbol($version)]($style)\\]";
          };
          kubernetes = {
            format = "\\[[$symbol$context( \\($namespace\\))]($style)\\]";
          };
          lua = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          memory_usage = {
            symbol = " ";
            format = "\\[$symbol[$ram( | $swap)]($style)\\]";
          };
          nix_shell = {
            symbol = " ";
            format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
          };
          nodejs = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          python = {
            # symbol = " ";
            format = "($virtualenv) ";
            # format =
            #   "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
          };
          rust = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          sudo = {
            format = "\\[[as $symbol]\\]";
          };
          terraform = {
            format = "\\[[$symbol$workspace]($style)\\]";
          };
          time = {
            format = "\\[[$time]($style)\\]";
          };
          username = {
            format = "\\[[$user]($style)\\]";
          };
          zig = {
            format = "\\[[$symbol($version)]($style)\\]";
          };
        }
        // builtins.fromTOML (
          builtins.readFile (
            pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "starship";
              rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
              sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
            }
            + /palettes/${flavour}.toml
          )
        );
    };
}
