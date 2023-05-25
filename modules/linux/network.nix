{pkgs,lib,username,hostname,...}
:{
    networking = {
        hostName = hostname;
        networkmanager.enable = true;
    };

   services.openssh = {
   enable = true;
   settings.passwordAuthentication = false;
   settings.kbdInteractiveAuthentication = false;
   };
   programs.ssh.startAgent = true;

}
