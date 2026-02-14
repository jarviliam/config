{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "github-actions-languageserver";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "strozw";
    repo = "github-actions-languageserver";
    rev = version;
    hash = "sha256-vLNhiUlxMz9U9a4+WJjPI+I4kIyvJa+BZWe89tVRO+Y=";
  };

  npmDepsHash = "sha256-0uTEN3KF5JcpGwZ0YVdqAQyJVMax0c1b93+fdA/PPOs=";

  meta = {
    description = "CLI Script for exec `@actions/languageserver";
    homepage = "https://github.com/strozw/github-actions-languageserver";
    license = lib.licenses.mit;
    mainProgram = "github-actions-languageserver";
    platforms = lib.platforms.all;
  };
}
