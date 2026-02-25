# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    # https://gethomepage.dev/latest/configs/settings/
    settings = {
      layout = {
        infra = {
          style = "row";
          columns = 2;
        };
      };
    };

    # https://gethomepage.dev/latest/configs/bookmarks/
    bookmarks = [ ];

    # https://gethomepage.dev/latest/configs/services/
    services = [
      {
        "Money" = [
          {
            "Budget" = {
              description = "Budget";
              href = "https://budget.fff666.org/";
            };
          }
        ];
      }
      {
        "Home" = [
          {
            "Home Assistant" = {
              href = "http://10.32.1.30:8123";
              description = "Home automation";
              icon = "home-assistant.svg";
              widget = {
                type = "homeassistant";
                url = "http://localhost:8123";
                key = "{{HOMEPAGE_VAR_HASS_TOKEN}}";
              };
            };
          }
        ];
      }
    ];

    # https://gethomepage.dev/latest/configs/service-widgets/
    widgets = [
      {
        resources = {
          label = "system";
          cpu = true;
          memory = true;
        };
      }
      {
        resources = {
          label = "storage";
          disk = [ "/mnt/NIXROOT" ];
        };
      }

    ];

    # https://gethomepage.dev/latest/configs/kubernetes/
    kubernetes = { };

    # https://gethomepage.dev/latest/configs/docker/
    docker = { };

    # https://gethomepage.dev/latest/configs/custom-css-js/
    customJS = "";
    customCSS = "";
    allowedHosts = "127.0.0.1:8082,10.32.1.100:8082";
    openFirewall = true;
  };
  nix.settings.trusted-users = [ "admin" ];
  networking.hostName = "nixos"; # Define your hostname.

  boot.supportedFilesystems = [ "zfs" ];

  virtualisation = {
    # Incus virtualization
    incus = {
      enable = true;
      ui.enable = true; # Enable web UI
      preseed = {
        storage_pools = [
          {
            name = "default";
            driver = "dir"; # Simple and compatible with any filesystem (ext4/btrfs)
            config = {
              source = "/var/lib/incus/storage-pools/default";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            devices = {
              eth0 = {
                name = "eth0";
                network = "bridged";
                parent = "br0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
          }
        ];
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      };
    };
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "incus-admin"
      "libvirtd"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6sJ9Oj3PnVYqgWraA+uW5MCrESyWD8Grizj3C9Yfrb"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    btop
    git
    qemu_kvm # QEMU with KVM support
    virt-manager # GUI for VM management
    libvirt # libvirt client tools
    bridge-utils # Network bridge utilities
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  nix.settings.experimental-features = "nix-command flakes";

  networking = {
    useDHCP = false;
    useNetworkd = true;
    hostId = "799fcb65";
    nftables.enable = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;

    # 1. Define the Bridge Device (The Virtual Switch)
    netdevs."20-br0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br0";
      };
    };

    networks = {
      # 2. Attach the Physical Ethernet to the Bridge
      "30-enp1s0f1" = {
        matchConfig.Name = "enp1s0f1";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };

      # 3. Configure the Bridge Interface (The Host IP)
      "40-br0" = {
        matchConfig.Name = "br0";
        address = [ "10.32.1.100/16" ];
        networkConfig = {
          Gateway = "10.32.0.1";
          DNS = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          IPv4Forwarding = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  services.logind.lidSwitchExternalPower = "ignore";
  system.stateVersion = "25.11"; # Did you read the comment?

}
