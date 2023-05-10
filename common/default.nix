{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my-home;
in
{
  imports = [
    ./zsh
    ./starship
    ./git
    ./wezterm
    # ./nvim
    ./tmux
  ];

  options.my-home = {
    includeFonts = lib.mkEnableOption "fonts";
    useNeovim = lib.mkEnableOption "neovim";
    isWork = lib.mkEnableOption "work profile";
    includeGames = lib.mkEnableOption "games";
  };

  config = {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        PAGER = "bat";
      };

      packages = with pkgs; [
        awscli2
        bat
        btop
        coreutils
        delta
        exa
        fd
        fzf
        font-awesome
        gcc
        gh
        go
        gopls
        home-manager
        htop
        iftop
        jetbrains-mono
        jq
        killall
        # skhd
        neofetch
        neovim
        nodePackages.npm
        nodejs
        openssh
        python311
        python311Packages.virtualenv
        ripgrep
        terraform-ls
        tflint
        tree
        # tmux
        unrar
        unzip
        wget
        yq
        zip
      ] ++ optionals cfg.isWork [
        docker
        docker-compose
        slack
        # insomnia
      ] ++ optionals cfg.includeFonts [
        nerdfonts
        noto-fonts
        noto-fonts-emoji
      ]
      ++ optionals (!cfg.useNeovim) [
        vim
      ];
    };
    # programs.command-not-found.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.bat = {
      enable = true;
    };
    nixpkgs.config = {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    };

    programs.nix-index.enable = true;

    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.05";

    programs.fzf = {
      enable = true;
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    };

    programs.zsh.initExtra = ''
      # The default fzf cd keybinding is alt+c, but thats already used by my terminal
      bindkey -M viins '^x' fzf-cd-widget

      # `programs.zsh.defaultOptions` doesn't work, it sets `home.sessionVariables` which for some reason isnt respected by zsh
      # Theme taken from https://github.com/catppuccin/fzf/blob/895df5b036add4cfa0dcfa4d826ad1db79ebc08f/mocha.md
      export FZF_DEFAULT_OPTS=" \
          --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
          --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
          --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    '';
  };

}
