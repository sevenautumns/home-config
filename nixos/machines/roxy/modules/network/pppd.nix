{ config, lib, pkgs, ... }: {

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
    # for ppp0ifb routing
    qdiscConfig = {
      Parent = "ingress";
      Handle = "0xffff";
    };
    # Traffic Shaper
    cakeConfig = {
      Bandwidth = "40M"; # Upload Bandwidth (Same as provider sold bandwidth)
      CompensationMode = "ptm"; # VDSL compensation
      FlowIsolationMode = "triple";
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
      Bandwidth = "250M"; # Download Bandwidth (Same as provider sold bandwidth)
      CompensationMode = "ptm"; # VDSL compensation
      FlowIsolationMode = "triple";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-ppp0-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ $IFACE = "ppp0" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${pkgs.iproute2}/bin/tc filter add dev ppp0 parent ffff: matchall action mirred egress redirect dev ifbppp0
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
    file = ../../../../../secrets/ppp-1und1-secret.age;
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
