{pkgs,lib,username,hostname,...}
:{
    networking = {
        hostName = hostname;
        networkmanager.enable = true;
    };

   services.openssh = {
   enable = true;
   settings.PasswordAuthentication = false;
   settings.KbdInteractiveAuthentication = false;
   };
   programs.ssh.startAgent = true;

}
