{ lib, mkYarnPackage, fetchFromGitHub, ... }:
mkYarnPackage rec {
  pname = "vtsls";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = pname;
    rev = "server-v${version}";
    hash = "sha256-M9VA67Ix2aKS5V0cA0cFPXkASoAyFxW6rEopSYXtyiA=";
  };

  packageJSON = "${src}/package.json";
  yarnLock = "${src}/yarn.lock";

  buildPhase = ''
    yarn build
  '';

  distPhase = "true";

  meta = with lib; {
    mainProgram = "vtsls";
    description = "This is an LSP wrapper around TypeScript extension bundled with VSCode. All features and performance are nearly the same.";
    homepage = "https://github.com/yioneko/vtsls";
    license = licenses.isc;
  };
}
