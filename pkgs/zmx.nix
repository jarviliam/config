{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.6.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/neurosnap/zmx/releases/download/v${version}/zmx-${version}-linux-x86_64.tar.gz";
      hash = "sha256-MJ2RO5gq4W6sKoVPQR3kDszAtkr+2JKqAqC+NR8CccE=";
    };
    aarch64-linux = {
      url = "https://github.com/neurosnap/zmx/releases/download/v${version}/zmx-${version}-linux-aarch64.tar.gz";
      hash = "sha256-wj9LTKgOFE4ynQQrkarkhZ0jIXqwcHazg69BNNl/qsU=";
    };
  };

  src-info =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "zmx";
  inherit version;

  src = fetchurl {
    inherit (src-info) url hash;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    ZMX_BIN="$(find . -maxdepth 4 -type f -name zmx -perm -u+x | head -n1)"
    if [ -z "$ZMX_BIN" ]; then
      echo "zmx binary not found in tarball" >&2
      exit 1
    fi
    install -m755 "$ZMX_BIN" "$out/bin/zmx"
  '';

  meta = with lib; {
    description = "zmx (pinned upstream tarball)";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
