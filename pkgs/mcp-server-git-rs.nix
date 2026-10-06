{
  lib,
  pkgs,
  stdenv,
}:
let
  packages = {
    aarch64-linux = {
      suffix = "aarch64-unknown-linux-gnu";
      hash = "sha256-ouSMFAyu+nPipZsBKKptGhWK2nYzpugj8MhG5tSYbdY=";
    };
    aarch64-darwin = {
      suffix = "aarch64-apple-darwin";
      hash = "sha256:623190501cebb943d4995c11749573e41764d728f85d6aff325773a0d8152dbd";
    };
    x86_64-linux = {
      suffix = "x86_64-unknown-linux-gnu";
      hash = "sha256:a5221bc46ec30d30a2c3e789650bd0d164f64366c9f1bea9a25c86a8acf0fab6";
    };
  };
  source =
    packages.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "mcp-server-git-rs";
  version = "0.2.1";

  src = pkgs.fetchurl {
    url = "https://github.com/karan-vk/${pname}/releases/download/v${version}/${pname}-v${version}-${source.suffix}.tar.gz";
    inherit (source) hash;
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D ${pname} $out/bin/${pname}

    runHook postInstall
  '';

  meta = {
    description = "Fast Rust MCP server exposing git repository operations over stdio";
    homepage = "https://github.com/karan-vk/mcp-server-git-rs";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
