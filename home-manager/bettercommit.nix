{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "better-commits";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    rev = "v${version}";
    hash = "sha256-70PEcktGGck7egDmaIteFEMCNpo6ZuWyIVPiOywr2tc=";
  };

  npmDepsHash = "sha256-g34UutgT5315BpsQSuGGLIU6Ga+hpEz74HNLKKOB+ec=";

  meta = with lib; {
    description = "Better commits";
    homepage = "https://github.com/Everduin94/better-commits";
    license = licenses.mit;
    mainProgram = "better-commits";
  };
}
