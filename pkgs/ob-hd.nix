{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  nodejs,
  makeWrapper,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "obsidianmd";
    repo = "obsidian-headless";
    rev = "46e3d163a54fba39f3b8864045d02a58a3d4161a";
    hash = "sha256-4YwaWQu/257jBN4NsM3QObOp/e3AUcdrpCuGOo70EBk=";
  };

  nativeBuildInputs = [
    nodejs
    pkgs.pnpm
    pnpmConfigHook
    makeWrapper
  ];

  # This is the "magic" part that replaces npmDepsHash
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-6ir0GHlub+iPxfanMvWNOCafdN654OIqwDjli+hLSLM=";
    fetcherVersion = 1;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # 1. Create the destination directory
    mkdir -p $out/lib/node_modules/obsidian-headless

    # 2. Copy everything (including the linked node_modules)
    cp -r . $out/lib/node_modules/obsidian-headless

    # 3. Create the executable bin directory
    mkdir -p $out/bin

    # 4. Wrap cli.js (Assuming it's in the root of the repo based on your comment)
    # If cli.js is inside a subfolder, adjust the path accordingly (e.g., /dist/cli.js)
    makeWrapper ${nodejs}/bin/node $out/bin/ob \
      --add-flags "$out/lib/node_modules/obsidian-headless/cli.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Headless Obsidian";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    license = licenses.mit;
    mainProgram = "ob";
    platforms = platforms.all;
  };
})
