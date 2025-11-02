{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  imports = [
    ../../common.nix
    ./desktop
    ./software/steam.nix
    ./rtmp.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
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

    # PROBE-RS
    ACTION!="add|change", GOTO="probe_rs_rules_end"

    SUBSYSTEM=="gpio", MODE="0660", GROUP="plugdev", TAG+="uaccess"

    SUBSYSTEM!="usb|tty|hidraw", GOTO="probe_rs_rules_end"

    # Please keep this list sorted by VID:PID

    # STMicroelectronics ST-LINK V1
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # STMicroelectronics ST-LINK/V2
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # STMicroelectronics ST-LINK/V2.1
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # STMicroelectronics STLINK-V3
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # SEGGER J-Link
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0101", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0102", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0103", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0104", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0105", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0107", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0108", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1001", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1002", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1003", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1004", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1005", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1006", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1007", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1008", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1009", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100c", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="100f", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1010", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1011", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1012", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1013", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1014", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1015", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1016", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1017", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1018", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1019", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101c", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="101f", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1020", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1021", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1022", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1023", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1024", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1025", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1026", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1027", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1028", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1029", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102c", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="102f", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1050", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1051", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1052", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1053", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1054", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1055", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1056", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1057", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1058", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1059", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105c", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="105f", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1060", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1061", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1062", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1063", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1064", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1065", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1066", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1067", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1068", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="1069", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106b", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106c", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106d", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106e", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106f", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # FT232H
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="660", GROUP="plugdev", TAG+="uaccess"
    # FT2232x
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="660", GROUP="plugdev", TAG+="uaccess"
    # FT4232H
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # FTDI-based Olimex devices
    ATTRS{idVendor}=="0x15ba", ATTRS{idProduct}=="0x0003", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0x15ba", ATTRS{idProduct}=="0x0004", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0x15ba", ATTRS{idProduct}=="0x002a", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="0x15ba", ATTRS{idProduct}=="0x002b", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # Espressif USB JTAG/serial debug unit
    ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="660", GROUP="plugdev", TAG+="uaccess"
    # Espressif USB Bridge
    ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1002", MODE="660", GROUP="plugdev", TAG+="uaccess"

    # CMSIS-DAP compatible adapters
    ATTRS{product}=="*CMSIS-DAP*", MODE="660", GROUP="plugdev", TAG+="uaccess"
    # WCH Link (CMSIS-DAP compatible adapter)
    ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8010", MODE="660", GROUP="plugdev", TAG+="uaccess"
    ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="8011", MODE="660", GROUP="plugdev", TAG+="uaccess"

    LABEL="probe_rs_rules_end"
  '';
  systemd.services."controller-keep-alive@".serviceConfig = {
    StandardOutput = "null";
    Type = "simple";
    User = "1000";
    ExecStart = "${getExe' pkgs.coreutils "cat"} /dev/input/%i";
  };

  xdg.portal.enable = true;
  # xdg.portal.config.common.default = "*";
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  # xdg.portal.configPackages = [ pkgs.gnome-session ];
  # xdg.portal.wlr.settings = {
  #   # screencast = {
  #   #   output_name = "DP-1";
  #   #   max_fps = 60;
  #   #   chooser_type = "simple";
  #   #   chooser_cmd = "${getExe pkgs.slurp} -f %o -or";
  #   # };
  #   screencast = {
  #     chooser_type = "dmenu";
  #     chooser_cmd = getExe pkgs.bemenu;
  #   };
  # };

  # services.fwupd.enable = true;
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  programs.niri.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "niri";
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      pkgs.amf
      rocmPackages.rocm-runtime
    ];
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

  security = {
    polkit.enable = true;
    #fix swaylock
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
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
    options = [
      "auto"
      "nofail"
    ];
  };

  fileSystems."/media/nvmedata" = {
    device = "/dev/disk/by-uuid/3a21229f-02a1-453c-b276-9c7c3c4e36d3";
    fsType = "btrfs";
    options = [
      "auto"
      "nofail"
    ];
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
