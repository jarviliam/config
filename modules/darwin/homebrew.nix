{ ... }: {
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    casks = [ "ghostty" ];
    brews = [
      "llvm"
    ];
  };
}
