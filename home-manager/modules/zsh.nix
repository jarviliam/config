{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    historySubstringSearch.enable = true;
    # Hack because /etc/static isn't in $NIX_PROFILE
    initExtraBeforeCompInit = ''
      fpath+=(/etc/static/profiles/per-user/liam.jarvis/share/zsh/site-functions /etc/static/profiles/per-user/liam.jarvis/share/zsh/$ZSH_VERSION/functions /etc/static/profiles/per-user/liam.jarvis/share/zsh/vendor-completions )
    '';
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true; # ignore commands starting with a space
      save = 20000;
      size = 20000;
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
    };

    initExtra = ''
      alias my-opened-prs='gh pr list --search "is:open author:@me updated:$(date +"%Y-%m-%d")" --json number,title | jq -r ".[] | \"\(.number),\(.title)\"" | pbcopy'
      alias my-merged-prs='gh pr list --search "is:merged author:@me updated:$(date +"%Y-%m-%d")" --json number,title | jq -r ".[] | \"\(.number),\(.title)\"" | pbcopy'
      fancy-ctrl-z () {
        if [[ $#BUFFER -eq 0 ]]; then
          BUFFER="fg"
          zle accept-line -w
        else
          zle push-input -w
          zle clear-screen -w
        fi
      }
      zle -N fancy-ctrl-z
      bindkey '^Z' fancy-ctrl-z

      export PATH="/opt/homebrew/bin:$PATH"
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
      eval "$(luarocks path --bin)"
    '';
    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "B0mdmIqefbm5H8wSG1h41c/J4shA186OyqvivmSK42Q=";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.6.0";
          sha256 = "B0mdmIqefbm5H8wSG1h41c/J4shA186OyqvivmSK42Q=";
          # sha256 = "0na6b5b46k4473c53mv1wkb009i6b592gxpjq94bdnlz1kkcqwg6";
        };
      }
      {
        name = "zsh-vi-mode";
        file = "zsh-vi-mode.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.9.0";
          sha256 = "B0mdmIqefbm5H8wSG1h41c/J4shA186OyqvivmSK42Q=";
          # sha256 = "0na6b5b46k4473c53mv1wkb009i6b592gxpjq94bdnlz1kkcqwg6";
        };
      }
      {
        name = "fzf-tab";
        file = "fzf-tab.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          sha256 = "dPe5CLCAuuuLGRdRCt/nNruxMrP9f/oddRxERkgm1FE=";
        };
      }
      {
        name = "forgit";
        file = "forgit.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "23.08.1";
          sha256 = "YyPB7Kd6ScV0VVXR9wdxqd3oIyxdxRRgmK2c8E3uzWk=";
          # sha256 = "oBPN8ehz00cDIs6mmGfCBzuDQMLG5z3G6KetJ1FK7e8=";
        };
      }
      {
        name = "you-should-use";
        file = "you-should-use.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "1.7.3";
          sha256 = "/uVFyplnlg9mETMi7myIndO6IG7Wr9M7xDFfY1pG5Lc=";
        };
      }
    ];
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
          conda = {
            symbol = " ";
            format = "\\[[$symbol$environment]($style)\\]";
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
          julia = {
            symbol = " ";
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
          meson = {
            symbol = "喝 ";
            format = "\\[[$symbol$project]($style)\\]";
          };
          nim = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          nix_shell = {
            symbol = " ";
            format = "\\[[$symbol$state( \\($name\\))]($style)\\]";
          };
          nodejs = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          ocaml = {
            format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
          };
          python = {
            # symbol = " ";
            format = "($virtualenv) ";
            # format =
            #   "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
          };
          ruby = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          rust = {
            symbol = " ";
            format = "\\[[$symbol($version)]($style)\\]";
          };
          scala = {
            symbol = " ";
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
          vagrant = {
            format = "\\[[$symbol($version)]($style)\\]";
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
