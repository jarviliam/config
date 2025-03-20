{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = false; # Handled by plugin
    defaultKeymap = "viins";
    historySubstringSearch.enable = true;
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
      bc = "better-commits";
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

      dk = "docker";
      dc = "docker-compose";
      poe = "poetry";
      diff = "delta";
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

    initExtraBeforeCompInit = '''';
    initExtra = ''
      # Fixes FZF shell integration
      zvm_after_init(){
           source <(${pkgs.fzf}/bin/fzf --zsh)
        }
            # disable sorting when completing any command
            zstyle ':completion:complete:*:options' sort false

            # switch group using `<` and `>`
            zstyle ':fzf-tab:*' switch-group '<' '>'

            # trigger continuous trigger with space key
            zstyle ':fzf-tab:*' continuous-trigger 'space'

            # bind tab key to accept event
            zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'

            # accept and run suggestion with enter key
            zstyle ':fzf-tab:*' accept-line enter

            #### FZF-TAB SUGGESTION ADDITIONS ####
            # give a preview of commandline arguments when completing `kill`
            zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
            zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
              '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
            zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

             # preview environment variable
            zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
              fzf-preview 'echo ''${(P)word}'

            # Show systemd unit status
            zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

            # Show git
            # it is an example. you can change it
            zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
              'git diff $word | delta'
            zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
              'git log --color=always $word'
            zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
              'git help $word | bat -plman --color=always'
            zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
              'case "$group" in
              "commit tag") git show --color=always $word ;;
              *) git show --color=always $word | delta ;;
              esac'
            zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
              'case "$group" in
              "modified file") git diff $word | delta ;;
              "recent commit object name") git show --color=always $word | delta ;;
              *) git log --color=always $word ;;
              esac'

            # Preview tldr
            zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

            # Show command preview
            zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
              '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "''${(P)word}"'

        # Exa
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza -1 --color=always ''${(Q)realpath}'

         # Initialize homebrew
      if [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

    '';
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "jeffreytse/zsh-vi-mode"
        "Aloxaf/fzf-tab"
        "zsh-users/zsh-completions kind:fpath"
        "MichaelAquilina/zsh-you-should-use kind:defer"
        "chisui/zsh-nix-shell"
        "wfxr/forgit"
        "ohmyzsh/ohmyzsh path:lib" # load OMZ's library
        "ohmyzsh/ohmyzsh path:plugins/fancy-ctrl-z"
        "ohmyzsh/ohmyzsh path:plugins/kubectl"

        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zsh-users/zsh-history-substring-search"
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
