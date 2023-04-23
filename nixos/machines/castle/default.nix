{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    # ./modules/adguard.nix
    ./modules/docker.nix
    ./modules/wireguard.nix
    ../../common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [ "usbhid" ];
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "castle";
    # interfaces.eth0.ipv4.addresses = [{
      # address = "192.168.2.250";
      # prefixLength = 24;
    # }];
    # defaultGateway = "192.168.2.1";
    nameservers = [ "1.1.1.1" ];
    enableIPv6 = true;
  };

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  system.stateVersion = "22.05";
}
