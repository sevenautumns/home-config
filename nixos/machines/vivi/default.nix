{ config, lib, pkgs, modulesPath, inputs, ... }:
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  imports = [
    ../../common.nix
    ./desktop
    ./software/steam.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "xpad" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    (amdgpu-kernel-module.overrideAttrs (_: {
      patches = [ ./0001-enable-smu13-undervolting.patch ];
    }))
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.udev.packages = [ pkgs.yubikey-personalization ];

  virtualisation.docker.enable = true;
  users.users.autumnal.extraGroups = [ "docker" ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  systemd.services.undervolt = {
    description = "Undervolt GPU";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = "/sys";
    script = ''
      sleep 5
      echo 'vo -80' > /sys/class/drm/card1/device/pp_od_clk_voltage
      echo 'c' > /sys/class/drm/card1/device/pp_od_clk_voltage
    '';
  };

  services.zerotierone.joinNetworks = [
    "12ac4a1e711ec1f6" # Weebwork
  ];

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
  xdg.portal.config.common.default = "*";
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings = {
    screencast = {
      output_name = "DP-1";
      max_fps = 60;
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };

  # services.fwupd.enable = true;
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      rocm-opencl-icd
      rocmPackages.rocm-runtime
    ];
  };

  environment.variables = {
    OCL_ICD_VENDORS = "${pkgs.rocm-opencl-icd}/etc/OpenCL/vendors/";
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
  # services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ brlaser ];
  # services.avahi.enable = true;
  # services.avahi.nssmdns = true;

  virtualisation.podman.enable = true;

  services.blueman.enable = true;

  # environment.etc.u2f_keys = {
  #   text = "autumnal:*,o65pPMQU2m31y+DIpa5nPQ/Xc5CXwiSq98n8lIFQzTM=,eddsa,";
  #   mode = "0644";
  # };
  # services.pcscd.enable = true;
  # security.pam = {
  #   u2f = {
  #     enable = true;
  #     cue = true;
  #     # Utilize appId key for injecting pin requirement
  #     # appId = "pam://$HOSTNAME pinverification=1 userpresence=0";
  #     appId = "pam://$HOSTNAME";
  #     # authFile = "/etc/u2f_keys";
  #   };
  #   # services = {
  #   #   login.u2fAuth = true;
  #   #   sudo.u2fAuth = true;
  #   #   i3lock.u2fAuth = true;
  #   #   i3lock-color.u2fAuth = true;
  #   #   swaylock.u2fAuth = true;
  #   #   greetd.u2fAuth = true;
  #   # };
  # };

  # Required for wireguard
  networking.firewall.checkReversePath = false;

  networking.hostName = "vivi";

  # services.teamviewer.enable = true;
  # environment.systemPackages = with pkgs; [ teamviewer ];

  ### 500GB nixos
  # fileSystems."/media/nixos_500" = {
  #   device = "/dev/disk/by-uuid/dad978f1-bcf2-431a-b482-80fff36b4b74";
  #   fsType = "btrfs";
  # };

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

  fileSystems."/net/roxy" = {
    device = "roxy:/media";
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
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.11";
}
