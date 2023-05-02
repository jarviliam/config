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
    # ./nvim
    # ./tmux
  ];

  options.my-home = {
    includeFonts = lib.mkEnableOption "fonts";
    useNeovim = lib.mkEnableOption "neovim";
    isWork = lib.mkEnableOption "work profile";
    includeGames = lib.mkEnableOption "games";
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
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
        tmux
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

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.nix-index.enable = true;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.05";
  };

}
