{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    ./modules/docker.nix
    ./modules/nextcloud.nix
    ./modules/nginx.nix
    ./modules/syncplay.nix
    ./modules/torrent.nix
    ../../common.nix
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

  ### Cross Compilation ###
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

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
