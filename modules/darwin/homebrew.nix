{ ... }: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    casks = [
      "ghostty"
    ];
    brews = [
      "llvm"
      {
        name = "neurosnap/tap/zmx";
        trusted = true;
      }
    ];
  };
}
