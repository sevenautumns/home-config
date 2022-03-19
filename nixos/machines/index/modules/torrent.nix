{ pkgs, config, inputs, lib, ... }:
let
  transmission-exporter = pkgs.buildGoModule {
    name = "transmission-exporter";
    src = inputs.transmission-exporter;
    vendorSha256 = "sha256-YhmfrM5iAK0zWcUM7LmbgFnH+k2M/tE+f/QQIQmQlZs=";
  };
in {
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
      owner = "autumnal";
    };
    transmission_exporter = {
      file = ../../../../secrets/transmission_exporter.age;
      path = "/var/lib/transmission-exporter/auth";
    };
    nordvpn = {
      file = ../../../../secrets/nordvpn_index.age;
      path = "/var/lib/nordvpn/nordvpn.conf";
    };
  };

  services.transmission = {
    enable = true;
    user = "autumnal";
    group = "transmission";
    credentialsFile = "/var/lib/transmission/auth";
    settings = {
      download-dir = "/media/torrent_storage/completed";
      incomplete-dir = "/media/torrent_storage/incomplete";
      incomplete-dir-enabled = true;
      rpc-authentication-required = true;
      rpc-username = "admin";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
      speed-limit-down = 5000;
      speed-limit-down-enabled = true;
      speed-limit-up = 500;
      speed-limit-up-enabled = true;
      alt-speed-down = 5000;
      alt-speed-enabled = false;
      alt-speed-time-begin = 240;
      alt-speed-time-day = 127;
      alt-speed-time-enabled = true;
      alt-speed-time-end = 480;
      alt-speed-up = 1500;
      utp-enabled = false;
    };
  };

  systemd.services.transmission-forwarder = {
    enable = true;
    bindsTo = [ "transmission.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:9091,fork,reuseaddr,bind=0.0.0.0 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:9091"',nofork
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
      User = "autumnal";
      Group = "transmission";
    };
  };
  systemd.tmpfiles.rules =
    [ "d '/var/lib/flood' 0700 autumnal transmission - -" ];

  systemd.services.transmission-exporter = {
    enable = true;
    bindsTo = [ "transmission.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      WEB_ADDR=127.0.0.1:19091 \
      TRANSMISSION_USERNAME=admin \
      TRANSMISSION_PASSWORD=$(cat /var/lib/transmission-exporter/auth) \
      ${transmission-exporter}/bin/transmission-exporter
    '';
  };

  networking.firewall.allowedTCPPorts = [ 3030 9091 ];

  services.prometheus.scrapeConfigs = [{
    job_name = "transmission";
    static_configs = [{ targets = [ "localhost:19091" ]; }];
  }];
}
