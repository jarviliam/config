{
  nix-index-database,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ nix-index-database.homeModules.nix-index ];
  home = {
    enableNixpkgsReleaseCheck = false;
    preferXdgDirectories = true;

    language.base = "en_US.UTF-8";

    sessionVariables = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_ASK = "1";
      HOMEBREW_NO_COMPAT = "1";
      HOMEBREW_NO_ENV_HINTS = "1";
      HOMEBREW_NO_INSTALL_CLEANUP = "1";
    };
  };

  manual.manpages.enable = false;

  programs = {
    home-manager.enable = true;

    nh = {
      enable = true;

      clean = {
        enable = true;
        extraArgs = "--no-direnv --no-gcroots";
      };

      flake = "${config.xdg.configHome}/.setup";
    };

    nix-index = {
      enable = true;
      symlinkToCacheHome = true;
    };
  };
}
