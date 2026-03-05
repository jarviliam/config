{
  pkgs,
  lib,
  roles,
  ...
}:
let
  isLinux = pkgs.stdenvNoCC.isLinux;
  hasRole = role: lib.elem role roles;
in
{
  config = lib.mkIf (hasRole "dev" || hasRole "work") {
    home.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      gpg = {
        enable = true;
      };
      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
        };
      };
    };
    services.gpg-agent = {
      enable = isLinux;
      pinentry.package = pkgs.pinentry-tty;
      enableSshSupport = true;
      enableZshIntegration = true;
      # cache the keys forever so we don't get asked for a password
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };
  };
}
