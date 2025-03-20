{
  config,
  pkgs,
  username,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      wget
      xclip
      sbctl
      niv
      kitty # Initial hypr
    ];
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = false;
        device = "nodev";
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;
      };
      timeout = 5;
      systemd-boot.enable = true;
    };
  };

  hardware.graphics = {
    enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.command-not-found.enable = false;
  programs.gnupg.agent = {
    enable = true;
  };
  programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "lp"
      "scanner"
    ];
    shell = pkgs.zsh;
  };
}
