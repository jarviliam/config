{ config, pkgs, ... }: {
  imports = [
    ../../common
  ];

  my-home = {
    includeFonts = true;
    useNeovim = true;
    isWork = true;
  };
}
