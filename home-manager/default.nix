{
  pkgs,
  lib,
  roles,
  ...
}:
let
  hasRole = role: lib.elem role roles;
  enableAi = hasRole "dev" || hasRole "work";
in
{
  imports = lib.optionals enableAi [ ../modules/ai ];

  config = lib.mkIf (hasRole "dev" || hasRole "work") {
    programs = {
      gpg = {
        enable = true;
      };
    };

    services.gpg-agent = {
      enable = false;
      pinentry.package = pkgs.pinentry-tty;
      enableSshSupport = true;
      enableZshIntegration = true;
      # cache the keys forever so we don't get asked for a password
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };
  };
}
