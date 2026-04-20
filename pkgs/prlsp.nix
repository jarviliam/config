{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule ({
  name = "prlsp";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "toziegler";
    repo = "prlsp";
    rev = "v0.1.0";
    hash = "sha256-DzyEWnLXN1HOVVRv1h5blnQnnEcAY17O+LBUYKzTx+E=";
  };
  sourceRoot = "source/go";
  postPatch = ''
    substituteInPlace go.mod --replace-fail 'go 1.25.7' 'go 1.24'
  '';
  vendorHash = null;
  meta = with lib; {
    description = "LSP server that surfaces GitHub PR review comments as editor diagnostics";
    homepage = "https://github.com/toziegler/prlsp";
    license = licenses.mit;
    mainProgram = "prlsp";
  };
})
