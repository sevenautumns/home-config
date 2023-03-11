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
  services.udev.packages = [ pkgs.yubikey-personalization ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General.FastConnectable = "true";
      Policy = {
        ReconnectAttempts = 7;
        ReconnectIntervals = "1,2,4,8,16,32,64";
      };
    };
  };

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brlaser ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.blueman.enable = true;

  environment.etc.u2f_keys = {
    text =
      "autumnal:p9rGHlS4Y3nKZmLcsQHZH7m53MKA9ZDqdyvf+IpXfZBR0eLleOwWXOAeoeiG/oX73qYGg4rT+cekiMNlRmp8EA==,wC3Hac/a9VU5/QLC7wXNcSB5Xtp5mn46bIU+FPcI+o1apcvmb81oSUVse8NhRDieibsLkF5rf1RCgfP06+g3oA==,es256,+presence:FLspmqImrEqgYb+F4f0pcHSoaNsljwBgl07v1CqKGfayHzhlztBCYUHbZmnODJeAlJ7NwA8QwliBLa2rwCs5ZQ==,1DEa/B12f3itdL7R6YNDR89zzYdpmQnxjZA7UslizsP6cedkYxxW+QhJKBh+Nl+Q22omSp4y2weP5MFjrsA1Gg==,es256,+presence";
    mode = "0644";
  };
  # services.pcscd.enable = true;
  security.pam = {
    u2f = {
      enable = true;
      cue = true;
      # Utilize appId key for injecting pin requirement
      appId = "pam://$HOSTNAME pinverification=1";
      authFile = "/etc/u2f_keys";
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      i3lock.u2fAuth = true;
      i3lock-color.u2fAuth = true;
      greetd.u2fAuth = true;
    };
  };

  # Required for wireguard
  networking.firewall.checkReversePath = false;

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
