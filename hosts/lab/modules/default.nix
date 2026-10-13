{ lib, flakeLib, ... }:
{
  imports = lib.attrValues (lib.removeAttrs (flakeLib.discoverPackages ./. ) [ "default" ]);
}
