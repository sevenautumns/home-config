{ config, lib, pkgs, ... }: {

  # systemd.network.netdevs."50-mullvad" = {
  #   netdevConfig = {
  #     Kind = "vlan";
  #     Name = "mullvad.150";
  #   };
  #   vlanConfig = {
  #     Id = 150;
  #   };
  # };
  # systemd.network.networks."55-mullvad" = {
  #   matchConfig.Name = "mullvad.150";
  #   # dhcpPrefixDelegationConfig = {
  #   #   SubnetId = "auto";
  #   # };
  #   linkConfig = {
  #     RequiredForOnline = "no";
  #   };
  #   dhcpServerConfig = {
  #     DNS = "1.1.1.1";
  #     EmitDNS = true;
  #     EmitRouter = true;
  #     PoolOffset = 50;
  #     PoolSize = 1000000;
  #   };
  #   routingPolicyRules = [
  #     {
  #       routingPolicyRuleConfig = {
  #         Family = "both";
  #         IncomingInterface = "mullvad.150";
  #         Table = "mullvad";
  #       };
  #     }
  #   ];
  #   networkConfig = {
  #     # Domains = domain;
  #     Address = "172.16.0.2/12";
  #     EmitLLDP = "yes";
  #     # IPv6SendRA = true;
  #     # IPv6AcceptRA = false;
  #     # DHCPPrefixDelegation = true;
  #     DHCPServer = true;
  #   };
  #   cakeConfig.Bandwidth = "5M"; # Download Bandwidth Limit 
  #   networkConfig = {
  #     DHCP = "no";
  #   };
  # };
  # age.secrets = {
  #   mullvad_well = {
  #     file = ../../../../../secrets/mullvad_well.age;
  #     path = "/var/lib/mullvad/well";
  #     group = "systemd-network";
  #     mode = "640";
  #   };
  # };
  # systemd.network.config.routeTables = { mullvad = 150; };
  # # TODO connect to wireguard with systemd ? Or add ip ranges and address here aswell
  # systemd.network.netdevs."50-well" = {
  #   netdevConfig = {
  #     Kind = "wireguard";
  #     Name = "wg-well";
  #   };
  #   # linkConfig.RequiredForOnline = "no";
  #   wireguardConfig = {
  #     PrivateKeyFile = config.age.secrets.mullvad_well.path;
  #     RouteTable = "mullvad";
  #   };
  #   wireguardPeers = [
  #     {
  #       wireguardPeerConfig = {
  #         AllowedIPs = [ "0.0.0.0/0" ];
  #         Endpoint = "146.70.117.34:51820";
  #         PersistentKeepalive = 25;
  #         PublicKey = "9ldhvN7r4xGZkGehbsNfYb5tpyTJ5KBb5B3TbxCwklw=";
  #       };
  #     }
  #   ];
  # };
  # systemd.network.networks."55-well" = {
  #   matchConfig.Name = "wg-well";
  #   # linkConfig.RequiredForOnline = "no";
  #   networkConfig = {
  #     Address = "10.66.17.235/32"; # TODO add ipv6 too?
  #     DNS = "1.1.1.1";
  #   };
  #   cakeConfig.Bandwidth = "10M"; # Upload Bandwidth Limit
  # };

}
