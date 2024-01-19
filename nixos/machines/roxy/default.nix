{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    # ./modules/adguard.nix
    # ./modules/docker.nix
    ./modules/nftables.nix
    # ./modules/dhcp.nix
    ./modules/plex.nix
    ./modules/rr.nix
    ./modules/paperless.nix
    ./modules/ntp.nix
    ./modules/torrent.nix
    ./modules/niketsu.nix
    ./modules/restic.nix
    # ./modules/jellyfin.nix
    ../../common.nix
    # ../../syncthing.nix
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

  services.netdata.enable = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
  };

  networking.networkmanager.enable = lib.mkForce false;
  systemd.network.enable = true;

  networking = {
    hostName = "roxy";
    # interfaces = {
    #   enp1s0.ipv4.addresses = [{
    #     address = "192.168.178.2";
    #     prefixLength = 24;
    #   }];
    #   eth0.ipv4.addresses = [{
    #     address = "192.168.1.2";
    #     prefixLength = 24;
    #   }];
    # };
    # defaultGateway = {
    #   interface = "eth0";
    #   address = "192.168.178.1";
    # };
    # nameservers = [ "1.1.1.1" ];
    useDHCP = false;
    nat.enable = false;
    firewall.enable = false;
  };

  systemd.network.networks."10-wan" = {
    name = "enp1s0";
    linkConfig = {
      RequiredForOnline = "no";
    };
    networkConfig = {
      Address = "192.168.1.2/24";
      DHCP = "no";
    };
  };
  systemd.network.networks."20-lan" = {
    # name = "eth0";
    name = "enp2s0";
    dhcpPrefixDelegationConfig = {
      SubnetId = "auto";
    };
    linkConfig = {
      RequiredForOnline = "no";
    };
    dhcpServerConfig = {
      DNS = "1.1.1.1";
      NTP = "192.168.178.2"; # provide NTP
      EmitDNS = true;
      EmitNTP = true;
      EmitRouter = true;
      PoolOffset = 50;
      PoolSize = 200;
    };
    networkConfig = {
      VLAN = [ "mullvad.150" ];
      # Domains = domain;
      Address = "192.168.178.2/24";
      EmitLLDP = "yes";
      IPv6SendRA = true;
      IPv6AcceptRA = false;
      DHCPPrefixDelegation = true;
      DHCPServer = true;
    };
    networkConfig = {
      DHCP = "no";
    };
  };
  systemd.network.networks."30-ppp0" = {
    matchConfig.Name = "ppp0";
    name = "ppp0";
    linkConfig = {
      RequiredForOnline = "routable";
    };
    routes = [
      { routeConfig.Destination = "0.0.0.0/0"; }
      { routeConfig.Destination = "::/0"; }
    ];
    networkConfig = {
      KeepConfiguration = "static";
      DefaultRouteOnDevice = true; # Disable for dslite
      LinkLocalAddressing = "ipv6";
      DHCP = "ipv6";
      # Tunnel = "dslite"; # Required for dslite
    };
    extraConfig = ''
      [DHCPv6]
      PrefixDelegationHint= ::/56
      UseAddress = false
      UseDelegatedPrefix = true
      WithoutRA = solicit

      [DHCPPrefixDelegation]
      UplinkInterface=:self
    '';
    ipv6SendRAConfig = {
      # Let networkd know that we would very much like to use DHCPv6
      # to obtain the "managed" information. Not sure why they can't
      # just take that from the upstream RAs.
      Managed = true;
    };
  };
  # systemd.network.networks."40-dslite" = {
  #   matchConfig.Name = "dslite";
  #   linkConfig = {
  #     RequiredForOnline = "no";
  #   };
  #   routes = [
  #     { routeConfig.Destination = "0.0.0.0/0"; }
  #   ];
  # };
  # systemd.network.netdevs."40-dslite" = {
  #   netdevConfig = {
  #     Kind = "ip6tnl";
  #     Name = "dslite";
  #   };
  #   tunnelConfig = {
  #     Mode = "ipip6";
  #     Local = "slaac";
  #     # Local = "2001:9e8:69b8:a00:da5e:d3ff:fed4:add8";
  #     Remote = "2001:1438:fff:30::1"; # aftr.online.versatel.de 
  #     EncapsulationLimit = "none";
  #   };
  # };
  systemd.network.networks."40-ztbtovjx4h" = {
    matchConfig.Name = "ztbtovjx4h";
    # linkConfig.RequiredForOnline = "no";
    routes = [{ routeConfig.Destination = "192.168.194.0/24"; }];
    networkConfig = {
      Address = "192.168.194.51/24";
      DHCP = "ipv4";
    };
    cakeConfig.Bandwidth = "30M"; # Upload Bandwidth Limit
  };

  systemd.network.netdevs."50-mullvad" = {
    netdevConfig = {
      Kind = "vlan";
      Name = "mullvad.150";
    };
    vlanConfig = {
      Id = 150;
    };
  };
  systemd.network.networks."55-mullvad" = {
    matchConfig.Name = "mullvad.150";
    # dhcpPrefixDelegationConfig = {
    #   SubnetId = "auto";
    # };
    linkConfig = {
      RequiredForOnline = "no";
    };
    dhcpServerConfig = {
      DNS = "1.1.1.1";
      EmitDNS = true;
      EmitRouter = true;
      PoolOffset = 50;
      PoolSize = 1000000;
    };
    routingPolicyRules = [
      {
        routingPolicyRuleConfig = {
          Family = "both";
          IncomingInterface = "mullvad.150";
          Table = "mullvad";
        };
      }
    ];
    networkConfig = {
      # Domains = domain;
      Address = "172.16.0.2/12";
      EmitLLDP = "yes";
      # IPv6SendRA = true;
      # IPv6AcceptRA = false;
      # DHCPPrefixDelegation = true;
      DHCPServer = true;
    };
    cakeConfig.Bandwidth = "5M"; # Download Bandwidth Limit 
    networkConfig = {
      DHCP = "no";
    };
  };
  age.secrets = {
    mullvad_well = {
      file = ../../../secrets/mullvad_well.age;
      path = "/var/lib/mullvad/well";
      group = "systemd-network";
      mode = "640";
    };
  };
  systemd.network.config.routeTables = { mullvad = 150; };
  # networking.wireguard.interfaces.wg-well = {
  #   ips = [ "10.66.17.235/32" "fc00:bbbb:bbbb:bb01::3:11ea/128" ];
  #   table = "mullvad";
  #   privateKeyFile = config.age.secrets.mullvad_well.path;
  #   peers = [{
  #     publicKey = "9ldhvN7r4xGZkGehbsNfYb5tpyTJ5KBb5B3TbxCwklw=";
  #     allowedIPs = [ "0.0.0.0/0" "::0/0" ];
  #     endpoint = "146.70.117.34:51820";
  #     persistentKeepalive = 25;
  #   }];
  # };
  # TODO connect to wireguard with systemd ? Or add ip ranges and address here aswell
  systemd.network.netdevs."50-well" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = "wg-well";
    };
    # linkConfig.RequiredForOnline = "no";
    wireguardConfig = {
      PrivateKeyFile = config.age.secrets.mullvad_well.path;
      RouteTable = "mullvad";
    };
    wireguardPeers = [
      {
        wireguardPeerConfig = {
          AllowedIPs = [ "0.0.0.0/0" ];
          Endpoint = "146.70.117.34:51820";
          PersistentKeepalive = 25;
          PublicKey = "9ldhvN7r4xGZkGehbsNfYb5tpyTJ5KBb5B3TbxCwklw=";
        };
      }
    ];
  };
  systemd.network.networks."55-well" = {
    matchConfig.Name = "wg-well";
    # linkConfig.RequiredForOnline = "no";
    networkConfig = {
      Address = "10.66.17.235/32"; # TODO add ipv6 too?
      DNS = "1.1.1.1";
    };
    cakeConfig.Bandwidth = "10M"; # Upload Bandwidth Limit
  };

  services.pppd = {
    enable = true;
    peers = {
      oneplusone = {
        enable = true;
        autostart = true;
        config = ''
          debug

          plugin pppoe.so enp1s0

          noauth
          hide-password
          call 1und1-secret

          linkname ppp0

          persist
          maxfail 0
          holdoff 5

          noipdefault
          defaultroute
          # replacedefaultroute

          ipcp-accept-local
          ipcp-accept-remote

          lcp-echo-interval 15
          lcp-echo-failure 3
        '';
      };
    };
  };

  age.secrets."ppp-1und1-secret" = {
    file = ../../../secrets/ppp-1und1-secret.age;
    owner = "root";
    mode = "700";
    path = "/etc/ppp/peers/1und1-secret";
  };

  networking.nftables.enable = true;

  # networking.firewall.allowedTCPPorts = [
  #   # Kea
  #   67
  #   68

  #   2049 # NFS Server

  #   19999 # Netdata

  #   # Plex
  #   32400 # Media Server
  #   1900 # DLNA
  #   32469 # DLNA

  #   # Unifi
  #   8080 # Port for UAP to inform controller.
  #   8443 # UI
  #   # 8880 # Port for HTTP portal redirect, if guest portal is enabled.
  #   # 8843 # Port for HTTPS portal redirect, ditto.
  #   # 6789 # Port for UniFi mobile speed test.

  #   28981 # Paperless
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   # Unifi
  #   # 3478 # UDP port used for STUN.
  #   # 10001 # UDP port used for device discovery.
  # ];

  # Join share network
  services.zerotierone.joinNetworks = [
    "12ac4a1e711ec1f6" # Weebwork
  ];

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

  # Mount for nfs export
  # fileSystems = {
  #   "/export/media" = {
  #     device = "/media";
  #     options = [ "bind" ];
  #   };
  #   "/export/anime" = {
  #     device = "/media/anime";
  #     options = [ "bind" ];
  #   };
  #   "/export/movies" = {
  #     device = "/media/movies";
  #     options = [ "bind" ];
  #   };
  #   "/export/series" = {
  #     device = "/media/series";
  #     options = [ "bind" ];
  #   };
  # };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /media 10.0.0.0/13(rw,no_all_squash)
    /media/anime 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /media/movies 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /media/series 192.168.194.0/24(ro,all_squash,no_subtree_check)
  '';

  services.samba = {
    enable = true;
    nsswins = true;
    openFirewall = true;
    extraConfig = ''
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      anime = {
        browseable = "yes";
        comment = "Anime Share";
        path = "/media/anime";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      movies = {
        browseable = "yes";
        comment = "Movie Share";
        path = "/media/movies";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      series = {
        browseable = "yes";
        comment = "Series Share";
        path = "/media/series";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      consume = {
        browseable = "yes";
        comment = "Paperless Consume";
        path = "/media/paperless/consume";
        "guest ok" = "no";
        "read only" = "no";
      };
    };
  };

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  system.stateVersion = "23.05";
}
