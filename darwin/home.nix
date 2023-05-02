{ config, pkgs, lib, ... }:

let
  common-programs = import ../common/home.nix { config = config; pkgs = pkgs; lib = lib; };
in
{
  imports = [
    <home-manager/nix-darwin>
  ];
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix { };
      programs = common-programs // { };
      manual.manpages.enable = false;
    };
  };
}
