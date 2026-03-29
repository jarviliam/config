{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_22,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.7";

  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-jVmvWREgc3ulEMYR6pdhzjn0E3C56TzwgSKdZGZ4TPg=";
  };

  sourceRoot = "package";

  postPatch = ''
    cp ${./ob-hd-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-65i4eMcY312JsxYIbEvDGMMI7rdTfyPKU4fUyZTtpUg=";

  nativeBuildInputs = [ makeWrapper ];
  dontNpmBuild = true;

  postInstall = ''
    rm $out/bin/ob
    makeWrapper ${nodejs_22}/bin/node $out/bin/ob \
      --add-flags "$out/lib/node_modules/obsidian-headless/cli.js"
  '';

  meta = {
    description = "Headless client for Obsidian Sync";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    license = lib.licenses.unfree;
    mainProgram = "ob";
  };
}
