{ lib, pkgs }:
let
  lspServers = {
    go.command = lib.getExe pkgs.gopls;
    lua.command = lib.getExe pkgs.emmylua-ls;
    nix.command = lib.getExe pkgs.nil;
    rust = {
      command = lib.getExe pkgs.rust-analyzer;
      args = [ "--disable-build-scripts" ];
    };
    toml = {
      command = lib.getExe pkgs.tombi;
      args = [ "lsp" ];
    };
    typescript = {
      command = lib.getExe pkgs.typescript;
      args = [
        "--lsp"
        "--stdio"
      ];
    };
  };
  lspExtensions = {
    go = [ ".go" ];
    lua = [ ".lua" ];
    nix = [ ".nix" ];
    rust = [ ".rs" ];
    toml = [ ".toml" ];
    typescript = [
      ".ts"
      ".tsx"
      ".js"
      ".jsx"
    ];
  };

  toLspConfig = name: server: {
    command = [ server.command ] ++ (server.args or [ ]);
    extensions = lspExtensions.${name};
  };
in
lib.mapAttrs toLspConfig lspServers
