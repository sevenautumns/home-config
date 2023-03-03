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

  services.blueman.enable = true;

  environment.etc.u2f_keys = {
    text =
      "autumnal:5eAaIrIDqpqg4l1LFx0NfMI/PFJX87eaAZWuLV6b4jHMo140i45lUgRjd/GhGfu6FX0o5dBAroSs9GMArcip9Q==,1nlOcyHeDURYiDZUeKKTcEGXIybFwv9Bkxg6+4Tyv1Iq4SaX7s8R6IJfzyKK3QDJ30bpHnDzCwtsJwyeelq6gQ==,es256,+presence:sv3VtdnNk3n/gWG8DWOa/sJpYtcUY5v+TeVXCZXPuRy+R68u0xhfmBJAe3PUU4P6+fxho+ynaLqRjXPHuoKetw==,K7hDKUYhq+bM/+XEY6rQVBLxTfDYhGN6K8Miu1inIxv7g3MRrkzrPrbw3HFNuPFC9D6tyHAQur0cAvHy842Tfw==,es256,+presence";
    mode = "0644";
  };
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
