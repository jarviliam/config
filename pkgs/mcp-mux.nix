{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-mux";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "thebtf";
    repo = "mcp-mux";
    rev = "3be8d5c809ae6204f8140cbed2d7805c4c9e7509";
    hash = "sha256-X4lVpJqWptxkKPZfPTNKvMLUr9WlgtcKkEA/VI2c3Wk=";
  };

  vendorHash = "sha256-zFP1D8KmBoBPjfjEZax+Gx42kUtGMTqm8Pk30SpNrno=";
  doCheck = false;

  subPackages = [ "cmd/mcp-mux" ];

  ldflags = [ "-s" ];

  meta = {
    description = "Transparent stdio multiplexer for MCP servers — share one upstream across multiple Claude Code sessions";
    homepage = "https://github.com/thebtf/mcp-mux";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
