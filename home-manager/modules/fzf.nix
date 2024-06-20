{ config, pkgs, ... }: {
  programs.fzf = {
    enable = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
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
