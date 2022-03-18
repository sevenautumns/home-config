{ pkgs, config, ... }: {
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # TODO delete on start if exists
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  systemd.services.wg = {
    description = "wg network interface";
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "netns@wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs;
        writers.writeBash "wg-up" ''
          ${iproute}/bin/ip link add wg0 type wireguard
          ${iproute}/bin/ip link set wg0 netns wg
          ${iproute}/bin/ip -n wg address add 10.5.0.2/32 dev wg0
          ${iproute}/bin/ip netns exec wg \
            ${wireguard}/bin/wg setconf wg0 /var/lib/nordvpn/nordvpn.conf
          ${iproute}/bin/ip -n wg link set wg0 up
          ${iproute}/bin/ip -n wg link set lo up
          ${iproute}/bin/ip -n wg route add default dev wg0
        '';
      ExecStop = with pkgs;
        writers.writeBash "wg-down" ''
          ${iproute}/bin/ip -n wg route del default dev wg0
          ${iproute}/bin/ip -n wg link del wg0
        '';
    };
  };

  age.secrets.nordvpn = {
    file = ../secrets/nordvpn.age;
    path = "/var/lib/nordvpn/nordvpn.conf";
  };

  # Assertions guaranteeing Wireguard usage
  assertions = [
    {
      # This is for guaranteeing that the deluged service still exists and the name didn"t change
      assertion = config.systemd.services.deluged.enable;
      message = ''
        Deluge Daemon service changed!
        Please verify Wireguard usage
      '';
    }
    {
      # This is for guaranteeing that we are using the wireguard namespace with the deluged service
      assertion =
        config.systemd.services.deluged.serviceConfig.NetworkNamespacePath
        == "/var/run/netns/wg";
      message = "Deluge Daemon Network namespace changed!";
    }
  ];

  systemd.services.deluged = {
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "wg.service" ];
    serviceConfig.NetworkNamespacePath = "/var/run/netns/wg";
  };
  systemd.services.delugeweb = {
    bindsTo = [ "netns@wg.service" ];
    serviceConfig.NetworkNamespacePath = "/var/run/netns/wg";
  };
}
