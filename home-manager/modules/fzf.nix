{ config, pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    colors = {
      "fg" = "#848d97";
      "bg" = "#30363d";
      "hl" = "#ffffff";
      "fg+" = "#e6edf3";
      "bg+" = "#313f50";
      "hl+" = "#ffa657";
      "info" = "#d29922";
      "prompt" = "#2f81f7";
      "pointer" = "#a371f7";
      "marker" = "#3fb950";
      "spinner" = "#6e7681";
      "header" = "#495058";
    };
    # colors = {
    #   "bg+" = "#414559";
    #   bg = "#303446";
    #   spinner = "#f2d5cf";
    #   hl = "#e78284";
    #   fg = "#c6d0f5";
    #   header = "#e78284";
    #   info = "#ca9ee6";
    #   pointer = "#f2d5cf";
    #   marker = "#f2d5cf";
    #   "fg+" = "#c6d0f5";
    #   prompt = "#ca9ee6";
    #   "hl+" = "#e78284";
    # };
  };
}
