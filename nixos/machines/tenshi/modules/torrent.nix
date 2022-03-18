{ pkgs, config, ... }: {
  imports = [ ../../../torrent.nix ];

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

  age.secrets.deluge_auth = {
    file = ../../../../secrets/deluge_auth.age;
    path = "/var/lib/deluge/auth";
    owner = "deluge";
  };

  services.deluge = {
    enable = true;
    user = "deluge";
    group = "nextcloud";
    web.enable = true;
    declarative = true;
    authFile = "/var/lib/deluge/auth";
    config = {
      "stop_seed_at_ratio" = true;
      "stop_seed_ratio" = 1.0;
      "download_location" = "/var/lib/deluge/incomplete";
      "move_completed" = true;
      "move_completed_path" = "/var/lib/deluge/completed";
    };
  };

  systemd.services.delugeweb-forwarder = {
    enable = true;
    bindsTo = [ "delugeweb.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:58846,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:58846"',nofork &
      ${pkgs.socat}/bin/socat tcp-listen:8112,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:8112"',nofork
    '';
  };

  services.nginx.virtualHosts = {
    "torrent.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      basicAuthFile = "/var/lib/transmission/basicauth";
      locations."/".proxyPass = "http://127.0.0.1:8112";
    };
  };
}
