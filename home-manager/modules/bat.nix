{ config, pkgs, lib, ... }:

let
  pager =
    "${pkgs.less}/bin/less --mouse --raw-control-chars --wheel-lines=1 --quit-if-one-screen";
in {
  # Cache needs to be rebuild for the themes to show up
  home.activation.bat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build 1>/dev/null
  '';


  programs.bat.enable = true;
  # Export this so that programs such as delta can use it
  programs.zsh.initExtra =
    lib.optionalString (pkgs.stdenv.isDarwin && config.programs.zsh.enable) ''
      export BAT_PAGER='${pager}'
    '';
}
