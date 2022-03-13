{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    ./modules/nix-flakes.nix
    ./modules/virtualisation-docker.nix
    ./modules/common.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];

  environment.systemPackages = with pkgs; [ libraspberrypi ];

  services.netdata.enable = true;
  services.adguardhome.enable = true;

  networking = {
    hostName = "index";
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.2";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.178.1";
    nameservers = [ "127.0.0.1" ];
    enableIPv6 = false;
  };

  networking.firewall.allowedTCPPorts = [
    53 # adguardhome dns
    139 # Samba
    445 # Samba
    2049 # NFS Server
    2342 # Grafana
    3000 # adguardhome admin
    6767 # Bazarr
    7878 # Radarr
    8080 # Scrunity
    8989 # Sonarr
    9000 # Portainer
    9091 # Transmission
    9117 # Jackett
    19999 # Netdata
    32400 # Plex
  ];

  networking.firewall.allowedUDPPorts = [
    53 # adguardhome dns
    137 # Samba
    138 # Samba
  ];

  # Join share network
  services.zerotierone.joinNetworks = [
    "12ac4a1e711ec1f6" # Weebwork
  ];

  services.grafana = {
    enable = true;
    domain = "localhost";
    port = 2342;
    addr = "10.4.0.0";
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    listenAddress = "127.0.0.1";
    scrapeConfigs = [{
      job_name = "transmission";
      static_configs = [{ targets = [ "localhost:19091" ]; }];
    }];
  };

  # Limit Bandwidth for weebwork network
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Limit WeebWork upload to 24mbits with 8192kbit bursts. Drop packages with more than 800ms latency
      # https://netbeez.net/blog/how-to-use-the-linux-traffic-control/
      # Use replace instead of add. This way id works whether its been added already or not
      "*/5 * * * *   root   tc qdisc replace dev ztbtovjx4h root tbf rate 24mbit burst 8192kbit latency 800ms"
    ];
  };

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media" = {
      device = "/dev/disk/by-label/storage";
      fsType = "btrfs";
      options = [ "noatime" ];
    };
  };

  #Disable Spindow: -S 0
  #Disable Power Managment: -B 255
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 0 /dev/sdb
    ${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sdb
  '';

  # Mount for nfs export
  fileSystems = {
    "/export/media" = {
      device = "/media";
      options = [ "bind" ];
    };
    "/export/anime" = {
      device = "/media/torrent_storage/anime";
      options = [ "bind" ];
    };
    "/export/movies" = {
      device = "/media/torrent_storage/movies";
      options = [ "bind" ];
    };
    "/export/series" = {
      device = "/media/torrent_storage/series";
      options = [ "bind" ];
    };
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export/media 10.0.0.0/13(rw,no_all_squash)
    /export/anime 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /export/movies 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /export/series 192.168.194.0/24(ro,all_squash,no_subtree_check)
  '';

  services.samba = {
    enable = true;
    nsswins = true;
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      anime = {
        browseable = "yes";
        comment = "Anime Share";
        path = "/media/torrent_storage/anime";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      movies = {
        browseable = "yes";
        comment = "Movie Share";
        path = "/media/torrent_storage/movies";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      series = {
        browseable = "yes";
        comment = "Series Share";
        path = "/media/torrent_storage/series";
        "guest ok" = "yes";
        "read only" = "yes";
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  system.stateVersion = "21.05";
}
