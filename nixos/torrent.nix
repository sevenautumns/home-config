{ pkgs, config, ... }: {

  # Define resolv.conf for wireguard namespace
  environment.etc."netns/wg/resolv.conf" = {
    text = ''
      nameserver 10.64.0.1
    '';
    mode = "0664";
  };

  age.secrets.mullvard_private = {
    file = ../secrets/mullvard_private.age;
    path = "/var/lib/mullvard/private";
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.65.8.0/32" ];
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
    privateKeyFile = "/var/lib/mullvard/private";
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

  # TODO use automatically created namespace for transmission instead
  # https://www.freedesktop.org/software/systemd/man/systemd.exec.html#PrivateNetwork=
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
