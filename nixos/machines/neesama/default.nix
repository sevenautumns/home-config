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
  boot.kernelPatches = [
    {
      name = "update-smu13";
      patch = pkgs.fetchpatch {
        name = "update-smu13";
        url = "https://patchwork.freedesktop.org/patch/540521/raw/";
        sha256 = "sha256-g4j0J57CIVDNRmVgxkGET7Xk6xBF3eLHJP/VgnRZRuQ=";
      };
    }
    {
      name = "fulfill-smu13";
      patch = pkgs.fetchpatch {
        name = "fulfill-smu13";
        url =
          "https://github.com/torvalds/linux/commit/8f4f5f0b901a444c2317ef0fb29f35bc296daa55.diff";
        sha256 = "sha256-de4RUTB1/ENaPi14QrTX/R/fUmrsrM3/6YJ32Yi3JMI=";
      };
    }
    {
      name = "fulfill-od";
      patch = pkgs.fetchpatch {
        name = "fulfill-od";
        url = "https://patchwork.freedesktop.org/patch/540523/raw/";
        sha256 = "sha256-CZ/E+e1aKfobs2s6FxB8KOptpbCNSrCXljeuIynwPsI=";
      };
    }
    {
      name = "fulfill-od-07";
      patch = pkgs.fetchpatch {
        name = "fulfill-od-07";
        url = "https://patchwork.freedesktop.org/patch/540524/raw/";
        sha256 = "sha256-l+d4elh540K1FxStEORFtvq386v/S1wnUmIub23NBfQ=";
      };
    }
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.udev.packages = [ pkgs.yubikey-personalization ];

  hardware.xpadneo.enable = true;

  # 8bitdo ultimate keep alive
  services.udev.extraRules = ''
    # 8bitdo ultimate 2.4ghz
    ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", ATTRS{id/vendor}=="2dc8", ATTRS{id/product}=="3106", TAG+="systemd", ENV{SYSTEMD_WANTS}="controller-keep-alive@%k"
  '';
  systemd.services."controller-keep-alive@".serviceConfig = {
    StandardOutput = "null";
    Type = "simple";
    User = "1000";
    ExecStart = "${pkgs.coreutils}/bin/cat /dev/input/%i";
  };

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings = {
    screencast = {
      output_name = "DP-1";
      max_fps = 30;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

  services.fwupd.enable = true;
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

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

  virtualisation.podman.enable = true;

  services.blueman.enable = true;

  environment.etc.u2f_keys = {
    text = "autumnal:*,o65pPMQU2m31y+DIpa5nPQ/Xc5CXwiSq98n8lIFQzTM=,eddsa,";
    mode = "0644";
  };
  # services.pcscd.enable = true;
  security.pam = {
    u2f = {
      enable = true;
      cue = true;
      # Utilize appId key for injecting pin requirement
      appId = "pam://$HOSTNAME pinverification=1 userpresence=0";
      authFile = "/etc/u2f_keys";
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      i3lock.u2fAuth = true;
      i3lock-color.u2fAuth = true;
      swaylock.u2fAuth = true;
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
