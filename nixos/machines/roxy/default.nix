{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    # ./modules/docker.nix
    ./modules/network
    ./modules/plex.nix
    ./modules/rr.nix
    ./modules/palworld.nix
    # ./modules/steamcmd.nix
    ./modules/paperless.nix
    ./modules/torrent.nix
    ./modules/niketsu.nix
    ./modules/restic.nix
    ../../common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.accept_ra" = "0";
    "net.ipv6.conf.all.autoconf" = "0";
    # "net.ipv6.conf.all.disable_ipv6" = 1;
    # "net.ipv4.ip_forward" = 1;
    # "net.ipv4.conf.all.src_valid_mark" = 1;
  };

  boot.kernelParams = [
    # Activate CGroup Memory control
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];

  services.netdata.enable = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.hello; # use ferretdb instead
  };
  services.ferretdb = {
    enable = true;
    package = pkgs.unstable.ferretdb;
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
      options = [ "noatime" "compress=zstd" ];
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
