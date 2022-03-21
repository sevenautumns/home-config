{ pkgs, config, ... }: {

  # Define resolv.conf for wireguard namespace
  environment.etc."netns/wg/resolv.conf" = {
    text = ''
      nameserver 103.86.96.100
      nameserver 103.86.99.100
    '';
    mode = "0664";
  };

  age.secrets.nordvpn_private = {
    file = ../secrets/nordvpn_private.age;
    path = "/var/lib/nordvpn/private";
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.5.0.2/32" ];
    preSetup = ''
      set -x
      ip netns del wg || true
      ip netns add wg
      ip -n wg link set dev lo up
    '';
    postShutdown = ''
      ip netns del wg || true
    '';
    interfaceNamespace = "wg";
    privateKeyFile = "/var/lib/nordvpn/private";
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
    bindsTo = [ "wireguard-wg0.service" ];
    requires = [ "network-online.target" ];
    after = [ "wireguard-wg0.service" ];
    # Make transmission run in network namespace wireguard (wg)
    serviceConfig.NetworkNamespacePath = "/var/run/netns/wg";

    # Re-add network namespace resolv.conf for transmission
    # Because Transmission overrides /etc and would use the original
    # /etc/resolv.conf otherwise
    serviceConfig.BindReadOnlyPaths =
      [ "/etc/netns/wg/resolv.conf:/etc/resolv.conf" ];
  };
}
