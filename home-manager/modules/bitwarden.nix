{
  pkgs,
  homeDirectory,
  lib,
  ...
}:
{
  home.packages = lib.optionals pkgs.stdenvNoCC.isLinux [ pkgs.bitwarden-desktop ];
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${homeDirectory}/.bitwarden-ssh-agent.sock";
  };
}
