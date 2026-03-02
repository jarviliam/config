{
  config,
  pkgs,
  lib,
  ...
}:
let
  roles = config.my.meta.roles or [ ];
  hasRole = role: lib.elem role roles;
in
{
  config = lib.mkIf (hasRole "dev") {
    # Cache needs to be rebuild for the themes to show up
    home.activation.bat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build 1>/dev/null
    '';

    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "base16";
      };
    };
  };
}
