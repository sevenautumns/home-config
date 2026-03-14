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
    routes = [ { Destination = "192.168.194.0/24"; } ];
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
      RTTSec = "30ms";
    };
  };

  systemd.network.networks."40-ifbztbtovjx4h" = {
    name = "ifbztbtovjx4h";
    cakeConfig = {
      Bandwidth = "100M"; # Download Bandwidth Limit
      FlowIsolationMode = "dual-dst-host";
      PriorityQueueingPreset = "besteffort";
      RTTSec = "30ms";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules = {
      setup-ztbtovjx4h-ifb = {
        onState = [ "configured" ];
        script = ''
          #!${pkgs.runtimeShell}
          if [ "$IFACE" = "ztbtovjx4h" ]; then
            # https://www.bufferbloat.net/projects/codel/wiki/Cake/#inbound-configuration-under-linux
            ${getExe' pkgs.iproute2 "tc"} filter add dev ztbtovjx4h parent ffff: matchall action mirred egress redirect dev ifbztbtovjx4h
          fi
        '';
      };
    };
  };
}
