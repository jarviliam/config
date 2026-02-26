{
  config,
  hostname,
  ...
}:
{
  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "10.32.1.100";
      Domains = [ "~." ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  programs.ssh.startAgent = true;
}
