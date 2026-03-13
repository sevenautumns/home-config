{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe';
in
{
  imports = [
    ./nftables.nix
    ./well.nix
    ./pppd.nix
    ./ntp.nix
    ./sss.nix
    ./dns.nix
  ];

  networking.networkmanager.enable = lib.mkForce false;
  systemd.network.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.accept_ra" = "0";
    "net.ipv6.conf.all.autoconf" = "0";
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.udp_rmem_min" = 16384;
    "net.ipv4.udp_wmem_min" = 16384;
  };

  networking = {
    useDHCP = false;
    nat.enable = false;
    firewall.enable = false;
  };

  systemd.network.wait-online.enable = false;

  # TODO improve naming
  # TODO improve organization
  systemd.network.networks."10-wan" = {
    name = "enp1s0";
    linkConfig = {
      RequiredForOnline = "no";
    };
    networkConfig = {
      VLAN = [ "enp1s0.7" ];
      Address = "10.10.1.2/24";
      DHCP = "no";
    };
  };

  # TODO improve naming
  # TODO improve organization
  systemd.network.netdevs."10-wan-vlan" = {
    netdevConfig = {
      Kind = "vlan";
      Name = "enp1s0.7";
    };
    vlanConfig = {
      Id = 7;
    };
  };

  # TODO improve naming
  # TODO improve organization
  systemd.network.networks."15-wan-vlan" = {
    matchConfig = {
      Name = "enp1s0.7";
      Kind = "vlan";
    };
    linkConfig = {
      RequiredForOnline = "no";
    };
    networkConfig = {
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
      DNS = "192.168.178.2"; # provide DNS
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
      RTTSec = "1ms";
    };
    networkConfig = {
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
    linkConfig = {
      RequiredForOnline = "no";
    };
    cakeConfig = {
      Bandwidth = "1G"; # Local Bandwidth
      FlowIsolationMode = "dual-src-host";
      PriorityQueueingPreset = "besteffort";
      RTTSec = "1ms";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-enp2s0-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ "$IFACE" = "enp2s0" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${getExe' pkgs.iproute2 "tc"} filter add dev enp2s0 parent ffff: matchall action mirred egress redirect dev ifbenp2s0
          fi
        '';
      };
    };
  };
}
