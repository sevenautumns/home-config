{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  inherit (lib.meta) getExe';
in
{
  systemd.network.netdevs = {
    # QoS concentrator
    "ifbppp0" = {
      netdevConfig = {
        Kind = "ifb";
        Name = "ifbppp0";
      };
    };
  };

  systemd.network.networks."30-ppp0" = {
    matchConfig.Name = "ppp0";
    name = "ppp0";
    linkConfig = {
      RequiredForOnline = "routable";
    };
    routes = [
      { Destination = "0.0.0.0/0"; }
      { Destination = "::/0"; }
    ];
    networkConfig = {
      KeepConfiguration = "static";
      DefaultRouteOnDevice = true; # Disable for dslite
      LinkLocalAddressing = "ipv6";
      DHCP = "ipv6";
      # Tunnel = "dslite"; # Required for dslite
    };
    # for ppp0ifb routing
    qdiscConfig = {
      Parent = "ingress";
      Handle = "0xffff";
    };
    # Traffic Shaper
    cakeConfig = {
      Handle = "5000";
      Bandwidth = "240M"; # Upload Bandwidth
      CompensationMode = "ptm";
      PriorityQueueingPreset = "diffserv4";
      FlowIsolationMode = "dual-src-host";
      NAT = true;
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

  systemd.network.networks."30-ifbppp0" = {
    name = "ifbppp0";
    # Traffic Shaper
    cakeConfig = {
      Handle = "5001";
      Bandwidth = "900M";
      CompensationMode = "ptm";
      PriorityQueueingPreset = "diffserv4";
      FlowIsolationMode = "dual-dst-host";
      NAT = true;
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-ppp0-ifb = {
        onState = [ "configured" ];
        script =
          let
            ppp0Handle = config.systemd.network.networks."30-ppp0".cakeConfig.Handle;
            ifbppp0Handle = config.systemd.network.networks."30-ifbppp0".cakeConfig.Handle;
            torrentIP = builtins.head (lib.splitString ":" config.secure.transmission.peer.endpoint);
          in
          ''
            #!${pkgs.runtimeShell}
            if [ $IFACE = "ppp0" ]; then
              # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
              ${getExe' pkgs.iproute2 "tc"} filter add dev ppp0 parent ffff: matchall action mirred egress redirect dev ifbppp0

              # Place torrent traffic in the lowest tin
              ${getExe' pkgs.iproute2 "tc"} filter del dev ppp0 # clear previous filter
              ${getExe' pkgs.iproute2 "tc"} filter add dev ppp0 parent ${ppp0Handle}: protocol ip prio 1 u32 match ip dst ${torrentIP}/32 action skbedit priority ${ppp0Handle}:1
              ${getExe' pkgs.iproute2 "tc"} filter del dev ifbppp0 # clear previous filter
              ${getExe' pkgs.iproute2 "tc"} filter add dev ifbppp0 parent ${ifbppp0Handle}: protocol ip prio 1 u32 match ip src ${torrentIP}/32 action skbedit priority ${ifbppp0Handle}:1
            fi
          '';
      };
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

  services.pppd = {
    enable = true;
    peers = {
      oneplusone = {
        enable = true;
        autostart = true;
        config = ''
          debug

          plugin pppoe.so enp1s0.7

          noauth
          hide-password
          call 1und1-secret

          linkname ppp0

          persist
          maxfail 0
          holdoff 5

          # mru 1492
          # mtu 1500
          # default-mru

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
    file = flakeRoot + "/secrets/ppp-1und1-secret.age";
    owner = "root";
    mode = "700";
    path = "/etc/ppp/peers/1und1-secret";
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 5 * * *   root   systemctl restart pppd-oneplusone.service"
    ];
  };
}
