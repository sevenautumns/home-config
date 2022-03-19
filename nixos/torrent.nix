{ pkgs, config, ... }: {
  # Creates network namespace
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I || true";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  # Define resolv.conf for wireguard namespace
  environment.etc."netns/wg/resolv.conf" = {
    text = ''
      nameserver 103.86.96.100
      nameserver 103.86.99.100
    '';
    mode = "0664";
  };

  # Creates network namespace for/with wireguard
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
          # lo needs to be started because otherwise transmission can
          # not bind to 127.0.0.1:9091
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

  # Assertions guaranteeing Wireguard usage
  assertions = [
    {
      # This is for guaranteeing that the transmission service still exists and the name didn"t change
      assertion = config.systemd.services.transmission.enable;
      message = ''
        Transmission service changed!
        Please verify Wireguard usage
      '';
    }
    {
      # This is for guaranteeing that we are using the wireguard namespace with the transmission service
      assertion =
        config.systemd.services.transmission.serviceConfig.NetworkNamespacePath
        == "/var/run/netns/wg";
      message = "Transmission Network namespace changed!";
    }
  ];

  systemd.services.transmission = {
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "wg.service" ];
    # Make transmission run in network namespace wireguard (wg)
    serviceConfig.NetworkNamespacePath = "/var/run/netns/wg";

    # Re-add network namespace resolv.conf for transmission
    # Because Transmission overrides /etc and would use the original
    # /etc/resolv.conf otherwise
    serviceConfig.BindReadOnlyPaths =
      [ "/etc/netns/wg/resolv.conf:/etc/resolv.conf" ];
  };
}
