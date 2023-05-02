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

      packages = with pkgs; [ import (./packages.nix) ];
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
