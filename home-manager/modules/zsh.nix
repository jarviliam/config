{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    # dotDir = "~/.config/zsh";
    historySubstringSearch.enable = true;
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
      # builtins
      size = "du -sh";
      cp = "cp -i";
      mkdir = "mkdir -p";
      df = "df -h";
      free = "free -h";
      du = "du -sh";
      susu = "sudo su";
      op = "xdg-open";
      del = "rm -rf";
      sdel = "sudo rm -rf";
      lst = "ls --tree -I .git";
      lsl = "ls -l";
      lsa = "ls -a";
      null = "/dev/null";
      tmux = "tmux -u";
      tu = "tmux -u";
      tua = "tmux a -t";

      # overrides
      cat = "bat";
      ssh = "TERM=screen ssh";
      python = "python3";
      pip = "python3 -m pip";
      venv = "python3 -m venv";

      g = "git";
      kc = "kubectl";
      kca = "kubectl apply -f";
      ks = "k9s";
      ku = "kubie";
      dk = "docker";
      dc = "docker-compose";
      pd = "podman";
      pc = "podman-compose";
      li = "lima nerdctl";
      lc = "limactl";
      sc = "sudo systemctl";
      poe = "poetry";
      space = "ncdu";
      ca = "cargo";
      tf = "terraform";
      diff = "delta";
      nr = "npm run";
      py = "python";

      psf = "ps -aux | grep";
      lsf = "ls | grep";
      shut = "sudo shutdown -h now";
      socks = "ssh -D 1337 -q -C -N";

      # clean
      dklocal = "docker run --rm -it -v `PWD`:/usr/workdir --workdir=/usr/workdir";
      dkclean = "docker container rm $(docker container ls -aq)";

      # nix
      ne = "nvim -c ':cd ~/.nixpkgs' ~/.nixpkgs";
      clean = "nix-collect-garbage -d && nix-store --gc && nix-store --verify --check-contents --repair";
      nsh = "nix-shell";
      nse = "nix search nixpkgs";
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "0na6b5b46k4473c53mv1wkb009i6b592gxpjq94bdnlz1kkcqwg6";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.6.0";
          sha256 = "0na6b5b46k4473c53mv1wkb009i6b592gxpjq94bdnlz1kkcqwg6";
        };
      }
      {
        name = "zsh-vi-mode";
        file = "zsh-vi-mode.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.9.0";
          sha256 = "0na6b5b46k4473c53mv1wkb009i6b592gxpjq94bdnlz1kkcqwg6";
        };
      }
      {
        name = "forgit";
        file = "forgit.plugin.zsh";
        src = pkgs.fetchFromGitHub
          {
            owner = "wfxr";
            repo = "forgit";
            rev = "23.05.0";
            sha256 = "oBPN8ehz00cDIs6mmGfCBzuDQMLG5z3G6KetJ1FK7e8=";
            # src = "${pkgs.zsh-forgit}/share/forgit";
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
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "\${custom.elixir}"
        "$elm"
        "$erlang"
        "$golang"
        "$haskell"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$container"
        "$shell"
        "$character"
      ];
      aws = {
        disabled = true;
        symbol = "  ";
        format = "\\[[$symbol($profile)(\\($region\))(\\[$duration\\])]($style)\\]";
      };
      bun = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      buf = {
        symbol = " ";
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
      cobol = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      conda = {
        symbol = " ";
        format = "\\[[$symbol$environment]($style)\\]";
      };
      crystal = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      daml = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      dart = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      deno = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      directory = {
        read_only = " ";
      };
      docker_context = {
        disabled = true;
        symbol = " ";
        format = "\\[[$symbol$context]($style)\\]";
      };
      dotnet = {
        format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
      };
      custom.elixir = {
        command = "elixir --short-version";
        detect_files = [ "mix.exs" ];
        symbol = " ";
        format = "\\[[$symbol($output)]($style)\\]";
        style = "bold purple";
      };
      elixir = {
        disabled = true;
        symbol = " ";
        format = "\\[[$symbol($version \\(OTP $otp_version\\))]($style)\\]";
      };
      elm = {
        symbol = " ";
        format = "\\[[$symbol($version)]($style)\\]";
      };
      erlang = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      gcloud = {
        format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\]";
      };
      git_branch = {
        symbol = " ";
        format = "\\[[$symbol$branch]($style)\\]";
      };
      git_status = {
        stashed = "";
        format = "([\\[$all_status$ahead_behind\\]]($style))";
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
      openstack = {
        format = "\\[[$symbol$cloud(\\($project\\))]($style)\\]";
      };
      package = {
        disabled = true;
        symbol = " ";
        format = "\\[[$symbol$version]($style)\\]";
      };
      perl = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      php = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      pulumi = {
        format = "\\[[$symbol$stack]($style)\\]";
      };
      purescript = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      python = {
        symbol = " ";
        format = "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
      };
      raku = {
        format = "\\[[$symbol($version-$vm_version)]($style)\\]";
      };
      red = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      rlang = {
        symbol = "ﳒ ";
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
      spack = {
        symbol = "🅢 ";
        format = "\\[[$symbol$environment]($style)\\]";
      };
      sudo = {
        format = "\\[[as $symbol]\\]";
      };
      swift = {
        format = "\\[[$symbol($version)]($style)\\]";
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
      vlang = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
      zig = {
        format = "\\[[$symbol($version)]($style)\\]";
      };
    };
  };
}
