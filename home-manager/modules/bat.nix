{ config, pkgs, lib, ... }:

let
  pager =
    "${pkgs.less}/bin/less --mouse --raw-control-chars --wheel-lines=1 --quit-if-one-screen";
in {
  programs.bat = let
    themes = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    };
  in {
    enable = true;
    themes = {
      "Catppuccin-latte" =
        builtins.readFile (themes + /Catppuccin-latte.tmTheme);
      "Catppuccin-mocha" =
        builtins.readFile (themes + /Catppuccin-mocha.tmTheme);
      "Catppuccin-frappe" =
        builtins.readFile (themes + /Catppuccin-frappe.tmTheme);
      "Catppuccin-macchiato" =
        builtins.readFile (themes + /Catppuccin-macchiato.tmTheme);
    };
    config = {
      theme = "Catppuccin-frappe";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin { inherit pager; };
  };

  # Cache needs to be rebuild for the themes to show up
  home.activation.bat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build 1>/dev/null
  '';

  # Export this so that programs such as delta can use it
  programs.zsh.initExtra =
    lib.optionalString (pkgs.stdenv.isDarwin && config.programs.zsh.enable) ''
      export BAT_PAGER='${pager}'
    '';
}
