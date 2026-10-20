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
      "ghostty@tip"
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
