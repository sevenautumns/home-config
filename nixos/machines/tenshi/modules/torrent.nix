{ pkgs, config, lib, ... }: {
  imports = [ ../../../torrent.nix ];

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

  age.secrets = {
    transmission_auth = {
      file = ../../../../secrets/transmission_auth.age;
      path = "/var/lib/transmission/auth";
      owner = "transmission";
    };
  };

  networking.wireguard.interfaces.wg0.peers = [{
    publicKey = "SqAWBSVdnUJ859Bz2Nyt82rlSebMwPgvwQxIb1DzyF8=";
    allowedIPs = [ "0.0.0.0/0" ];
    endpoint = "ch298.nordvpn.com:51820";
    persistentKeepalive = 25;
  }];

  services.transmission = {
    enable = true;
    user = "transmission";
    group = "nextcloud";
    credentialsFile = "/var/lib/transmission/auth";
    settings = {
      download-dir = "/var/lib/transmission/completed";
      incomplete-dir = "/var/lib/transmission/incomplete";
      incomplete-dir-enabled = true;
      rpc-authentication-required = true;
      rpc-username = "admin";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
      utp-enabled = false;
    };
  };

  systemd.services.transmission-forwarder = {
    enable = true;
    bindsTo = [ "transmission.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:9091,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute2}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:9091"',nofork
    '';
  };

  systemd.services.flood = {
    enable = true;
    description = "Flood torrent UI";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.flood}/bin/flood"
        "--port 3030"
        "--host 0.0.0.0"
        "--rundir /var/lib/flood"
      ];
      User = "transmission";
      Group = "nextcloud";
    };
  };
  systemd.tmpfiles.rules =
    [ "d '/var/lib/flood' 0700 transmission nextcloud - -" ];

  services.nginx.virtualHosts = {
    "torrent.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:3030";
    };
  };
}
