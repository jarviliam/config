{ inputs, ... }:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  services.rex = {
    enable = true;
    extraListen = [ "http://192.168.64.2:7297" ];
    allowAnonymous = true;
  };

  programs.rex = {
    enable = true;
    sshGuard = false; # Preserve the existing, unmanaged SSH config.
  };
}
