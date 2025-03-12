{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  overlay = final: super: {
    makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
  };
in
{
  nixpkgs.overlays = [ overlay ];
  imports = [
    ../../common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "vc4"
  ];

  environment.systemPackages = with pkgs; [ libraspberrypi ];

  networking = {
    hostName = "ika";
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.178.12";
        prefixLength = 24;
      }
    ];
    # defaultGateway = "192.168.178.2";
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

  system.stateVersion = "24.05";
}
