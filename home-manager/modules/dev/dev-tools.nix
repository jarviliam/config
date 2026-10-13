{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      harper
      jq
      yq
      jwt-cli
      tailscale-acl-combiner
      typos-lsp
      lazygit
      zine

      redis
      pgcli
    ];
  };
}
