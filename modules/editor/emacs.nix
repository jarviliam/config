{ inputs, ... }:
{
  imports = [ inputs.nix-doom-emacs.homeModule ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ../../config/doom;
  };
}
