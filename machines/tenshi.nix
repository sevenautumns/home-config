{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    ./modules/nix-flakes.nix
    ./modules/virtualisation-docker.nix
    ./modules/common.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  networking.firewall.allowedTCPPorts = [ 80 443 8999 ];
  services.nextcloud = {
    enable = true;
    hostName = "cloud.autumnal.de";
    config = {
      adminuser = "autumnal";
      adminpassFile = "/var/lib/nextcloud/adminpassfile";
    };
  };
  services.syncplay = {
    enable = true;
    port = 8999;
    certDir = "/var/lib/acme/autumnal.de";
    group = "nginx";
  };
  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "autumnal.de" = {
      forceSSL = true;
      enableACME = true;
    };
    "docker.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:9000";
    };
    "cloud.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "friedrich122112@googlemail.com";
    certs = {
      "autumnal.de" = {
        postRun = ''
          cp key.pem privkey.pem
          systemctl restart syncplay.service
        '';
      };
    };
  };

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/878292bc-3d60-46ad-9098-78292e8bf7a7";
      fsType = "btrfs";
    };
  };
  swapDevices =
    [{ device = "/dev/disk/by-uuid/df5300c0-6b4f-495e-a9c7-87d7285cb962"; }];
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "21.11";
}
