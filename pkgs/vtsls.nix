{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  importNpmLock,
}:

buildNpmPackage rec {
  pname = "vtsls";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    rev = "server-v${version}";
    hash = "sha256-HCi9WLh4IEfhgkQNUVk6IGkQfYagg805Rix78zG6xt0=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/server";

  npmDeps = importNpmLock {
    npmRoot = "${src}/packages/server";
    packageLock = lib.importJSON ./package-lock.json;
  };

  npmDepsHash = "sha256-R70+8vwcZHlT9J5MMCw3rjUQmki4/IoRYHO45CC8TiI=";

  npmConfigHook = importNpmLock.npmConfigHook;

  dontNpmPrune = true;
}
