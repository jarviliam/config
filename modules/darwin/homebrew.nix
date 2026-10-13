{ ... }: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    casks = [
      "ghostty"
      "nikitabobko/tap/aerospace"
    ];
    brews = [
      "llvm"
    ];
  };
}
