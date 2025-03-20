{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    colors = {
      "fg" = "#fbf1c7"; # light foreground
      "bg" = "#3c3836"; # dark background
      "hl" = "#fabd2f"; # highlight
      "fg+" = "#ebdbb2"; # brighter foreground
      "bg+" = "#282828"; # slightly lighter background
      "hl+" = "#fe8019"; # brighter highlight
      "info" = "#8ec07c"; # info text
      "prompt" = "#d3869b"; # prompt text
      "pointer" = "#b8bb26"; # pointer
      "marker" = "#83a598"; # marker
      "spinner" = "#d65d0e"; # spinner
      "header" = "#d79921"; # header text
    };
    # colors = {
    #   "fg" = "#848d97";
    #   "bg" = "#30363d";
    #   "hl" = "#ffffff";
    #   "fg+" = "#e6edf3";
    #   "bg+" = "#313f50";
    #   "hl+" = "#ffa657";
    #   "info" = "#d29922";
    #   "prompt" = "#2f81f7";
    #   "pointer" = "#a371f7";
    #   "marker" = "#3fb950";
    #   "spinner" = "#6e7681";
    #   "header" = "#495058";
    # };
  };
}
