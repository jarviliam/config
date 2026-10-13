# Discover importable entries in a directory.
#
# Returns an attrset mapping:
# - `<file>.nix` -> `<dir>/<file>.nix`
# - `<subdir>/`  -> `<dir>/<subdir>`
#
# This is useful for module trees where both leaf modules and nested module
# directories should be imported the same way.
{ lib }:
dir:
let
  entries = builtins.readDir dir;

  isImportable = name: type: type == "directory" || lib.hasSuffix ".nix" name;

  toImport = name: _: {
    name = lib.removeSuffix ".nix" name;
    value = dir + "/${name}";
  };
in
lib.mapAttrs' toImport (lib.filterAttrs isImportable entries)
