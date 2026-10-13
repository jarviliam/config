{ ... }: {
  home.sessionVariables = {
    PAGER = "bat";
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };
}
