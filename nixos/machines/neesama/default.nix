{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    ../../common.nix
    ../../syncthing.nix
    ./desktop
    ./software/steam.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.unstable.linuxPackages_zen;
  boot.extraModulePackages = [ ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true;

  networking.hostName = "neesama";

  # services.teamviewer.enable = true;
  # environment.systemPackages = with pkgs; [ teamviewer ];

  ### 500GB nixos
  fileSystems."/media/nixos_500" = {
    device = "/dev/disk/by-uuid/dad978f1-bcf2-431a-b482-80fff36b4b74";
    fsType = "btrfs";
  };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/F5B3-D735";
  #   fsType = "vfat";
  # };
  ### 500GB nixos

  ### 1000GB nixos
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/36ac68d4-4473-4030-a30c-fabe8aee0c16";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/332D-612D";
    fsType = "vfat";
  };
  ### 1000GB nixos

  fileSystems."/media/ssddata" = {
    device = "/dev/disk/by-uuid/81c6fec5-b8e1-4d7a-b68e-39b16dcc2f86";
    fsType = "btrfs";
  };

  # fileSystems."/media/arch" = {
  #   device = "/dev/disk/by-uuid/9e37651d-1ad9-4d3c-bdfc-90e4857f38ae";
  #   fsType = "btrfs";
  # };

  fileSystems."/net/index" = {
    device = "index:/export/media";
    fsType = "nfs";
    noCheck = true;
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=4s"
      "x-systemd.mount-timeout=4s"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.amd.updateMicrocode =
    config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.11";
}
