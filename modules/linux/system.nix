{config, pkgs,username, ...}: {
    environment = {
        systemPackages = with pkgs; [
        vim
        git
        wget
        xclip
        ];
        };
        boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	loader = {
#		systemd-boot.enable = true;
		efi = {
		 canTouchEfiVariables = true;
		 efiSysMountPoint = "/boot/efi";
};
		grub = {
		enable = true;
		device = "nodev";
		devices = ["nodev"];
		efiSupport = true;
		useOSProber = true;
		configurationLimit = 5;
};
	timeout = 5;
};
        };
        fonts.packages = with pkgs; [
 noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  roboto
    source-code-pro
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
        ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  nixpkgs.config.pulseaudio = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
programs.zsh.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "lp" "scanner" ];
    shell = pkgs.zsh;
  };
}
