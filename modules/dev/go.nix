{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      go
      gopls
      delve
      go-testfixtures
      golangci-lint
    ];
  };
}
