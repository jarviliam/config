{ lib, stdenv, fetchurl, unzip }:
stdenv.mkDerivation rec {
  pname = "finch";
  version = "1.0.0";

  src = if stdenv.isAarch64 then
    fetchurl {
      url =
        "https://github.com/runfinch/finch/releases/download/v${version}/Finch-v${version}-aarch64.pkg";
      hash = "sha256-TIoda2kDckK1FBLAmKudsDs3LXO4J0KWiAD2JlFb4rk=";
    }
  else
    fetchurl {
      url =
        "https://github.com/runfinch/finch/releases/download/v${version}/Finch-v${version}-x86_64.pkg";
      hash = "sha256-TIoda2kDckK1FBLAmKudsDs3LXO4J0KWiAD2JlFb4rk=";
    };

  nativeBuildInputs = [ ];

  buildInputs = [ ];

  sourceRoot = if stdenv.isAarch64 then "goku" else ".";

  installPhase = ''
    chmod +x goku
    chmod +x gokuw
    mkdir -p $out/bin
    cp goku $out/bin
    cp gokuw $out/bin
  '';

  meta = with lib; {
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = licenses;
    maintainers = [ maintainers.nikitavoloboev ];
    platforms = platforms.darwin;
  };
}

