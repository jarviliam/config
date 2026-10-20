{ ... }: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    taps = [
      {
        name = "neurosnap/tap";
        trusted = true;
      }
    ];
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
