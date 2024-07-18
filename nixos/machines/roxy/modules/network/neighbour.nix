{ config, lib, pkgs, ... }: {
  systemd.network.netdevs = {
    # QoS concentrator
    "ifbneighbour" = {
      netdevConfig = {
        Kind = "ifb";
        Name = "ifbneighbour";
      };
    };
  };

  systemd.network.netdevs."60-neighbour" = {
    netdevConfig = {
      Kind = "vlan";
      Name = "neighbour.250";
    };
    vlanConfig = {
      Id = 250;
    };
  };
  systemd.network.networks."65-neighbour" = {
    matchConfig = {
      Name = "neighbour.250";
      Kind = "vlan";
    };
    dhcpPrefixDelegationConfig = {
      SubnetId = "auto";
    };
    linkConfig = {
      RequiredForOnline = "no";
    };
    dhcpServerConfig = {
      DNS = "1.1.1.1";
      EmitDNS = true;
      EmitNTP = true;
      EmitRouter = true;
      PoolOffset = 50;
      PoolSize = 200;
    };
    # for ifbneighbour routing
    qdiscConfig = {
      Parent = "ingress";
      Handle = "0xffff";
    };
    cakeConfig = {
      Bandwidth = "1G"; # Local Bandwidth
      FlowIsolationMode = "triple";
    };
    networkConfig = {
      Address = "192.168.250.2/24";
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
  systemd.network.networks."68-ifbneighbour" = {
    name = "ifbneighbour";
    cakeConfig = {
      Bandwidth = "1G"; # Local Bandwidth
      FlowIsolationMode = "triple";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-neighbour-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ $IFACE = "neighbour.250" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${pkgs.iproute2}/bin/tc filter add dev neighbour.250 parent ffff: matchall action mirred egress redirect dev ifbneighbour
          fi
        '';
      };
    };
  };
}
