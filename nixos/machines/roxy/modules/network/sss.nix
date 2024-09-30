{ config, lib, pkgs, ... }:
let inherit (lib.meta) getExe'; in {
  services.zerotierone.joinNetworks = [
    "12ac4a1e711ec1f6"
  ];

  systemd.network.netdevs = {
    # QoS concentrator
    "ifbztbtovjx4h" = {
      netdevConfig = {
        Kind = "ifb";
        Name = "ifbztbtovjx4h";
      };
    };
  };

  systemd.network.networks."40-ztbtovjx4h" = {
    matchConfig.Name = "ztbtovjx4h";
    # linkConfig.RequiredForOnline = "no";
    routes = [{ routeConfig.Destination = "192.168.194.0/24"; }];
    networkConfig = {
      Address = "192.168.194.51/24";
      DHCP = "ipv4";
    };
    # for ifbztbtovjx4h routing
    qdiscConfig = {
      Parent = "ingress";
      Handle = "0xffff";
    };
    cakeConfig = {
      Bandwidth = "150M"; # Upload Bandwidth Limit
      FlowIsolationMode = "dual-src-host";
      PriorityQueueingPreset = "besteffort";
    };
  };

  systemd.network.networks."40-ifbztbtovjx4h" = {
    name = "ifbztbtovjx4h";
    cakeConfig = {
      Bandwidth = "100M"; # Download Bandwidth Limit
      FlowIsolationMode = "dual-dst-host";
      PriorityQueueingPreset = "besteffort";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-ztbtovjx4h-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ $IFACE = "ztbtovjx4h" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${getExe' pkgs.iproute2 "tc"} filter add dev ztbtovjx4h parent ffff: matchall action mirred egress redirect dev ifbztbtovjx4h
          fi
        '';
      };
    };
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
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

}
