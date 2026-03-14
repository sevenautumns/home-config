{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    # ./modules/network # For when we are the router
    ./modules/network_guest.nix # For the classic network experience
    ./modules/plex.nix
    ./modules/rr.nix
    # ./modules/palworld.nix
    # ./modules/corekeeper.nix
    # ./modules/factorio.nix
    # ./modules/docker.nix
    ./modules/paperless.nix
    ./modules/sss.nix
    ./modules/torrent.nix
    ./modules/restic.nix
    ../../common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    # Activate CGroup Memory control
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];

  networking = {
    hostName = "roxy";
  };

  # virtualisation.containers.enable = true;
  # virtualisation.libvirtd.enable = true;
  # virtualisation.libvirtd.onShutdown = "shutdown";
  # virtualisation.spiceUSBRedirection.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.unstable.mongodb-ce;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d93262ed-3cf4-4ed3-be10-298104a6c655";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E2B0-4009";
      fsType = "vfat";
    };
    "/media" = {
      device = "/dev/disk/by-uuid/5ea476f2-d9fd-4de8-9d53-b901caa88303";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /media 10.0.0.0/13(rw,no_all_squash)
  '';

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  system.stateVersion = "23.05";
}
