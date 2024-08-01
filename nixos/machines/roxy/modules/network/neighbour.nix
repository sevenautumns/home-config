{ config, lib, pkgs, ... }: {
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
    # Cake is not required here, because this traffic is already shaped by the underlying interface enp2s0
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
}
