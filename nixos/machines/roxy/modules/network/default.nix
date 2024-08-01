{ config, lib, pkgs, ... }:
let inherit (lib.meta) getExe'; in {
  imports = [
    ./nftables.nix
    ./well.nix
    ./pppd.nix
    ./ntp.nix
    ./sss.nix
    ./dns.nix
    ./neighbour.nix
  ];

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

  systemd.network.wait-online.enable = false;

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
    # for ifbenp2s0 routing
    qdiscConfig = {
      Parent = "ingress";
      Handle = "0xffff";
    };
    cakeConfig = {
      Bandwidth = "1G"; # Local Bandwidth
      FlowIsolationMode = "dual-dst-host";
      PriorityQueueingPreset = "besteffort";
    };
    networkConfig = {
      VLAN = [ "neighbour.250" ];
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

  systemd.network.netdevs = {
    # QoS concentrator
    "ifbenp2s0" = {
      netdevConfig = {
        Kind = "ifb";
        Name = "ifbenp2s0";
      };
    };
  };

  systemd.network.networks."40-ifbenp2s0" = {
    name = "ifbenp2s0";
    cakeConfig = {
      Bandwidth = "1G"; # Local Bandwidth
      FlowIsolationMode = "dual-src-host";
      PriorityQueueingPreset = "besteffort";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-enp2s0-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ $IFACE = "enp2s0" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${getExe' pkgs.iproute2 "tc"} filter add dev enp2s0 parent ffff: matchall action mirred egress redirect dev ifbenp2s0
          fi
        '';
      };
    };
  };
}
