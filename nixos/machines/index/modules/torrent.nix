{ pkgs, config, inputs, ... }:
let

  python = "python39";
  python-deluge-exporter = inputs.mach-nix.lib.${pkgs.system}.mkPython {
    requirements =
      builtins.readFile "${inputs.deluge-exporter}/requirements.txt";
  };
in {
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

  age.secrets = {
    deluge_auth = {
      file = ../../../../secrets/deluge_auth.age;
      path = "/var/lib/deluge/auth";
      owner = "autumnal";
    };
    deluge_exporter = {
      file = ../../../../secrets/deluge_exporter.age;
      path = "/var/lib/deluge-exporter/auth";
    };
  };

  services.deluge = {
    enable = true;
    user = "autumnal";
    group = "deluge";
    web.enable = true;
    declarative = true;
    authFile = "/var/lib/deluge/auth";
    config = {
      max_upload_slots_global = -1;
      enabled_plugins = [ "Label" ];
      download_location = "/media/torrent_storage/incomplete";
      move_completed = true;
      move_completed_path = "/media/torrent_storage/completed";
      max_download_speed = 5000;
      max_upload_speed = 500;
    };
  };

  systemd.services.delugeweb-forwarder = {
    enable = true;
    bindsTo = [ "delugeweb.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:58846,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:58846"',nofork &
      ${pkgs.socat}/bin/socat tcp-listen:8112,fork,reuseaddr,bind=192.168.178.2 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:8112"',nofork &
      ${pkgs.socat}/bin/socat tcp-listen:8112,fork,reuseaddr,bind=10.4.0.0 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:8112"',nofork &
      ${pkgs.socat}/bin/socat tcp-listen:8112,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:8112"',nofork
    '';
  };

  systemd.services.deluge-exporter = {
    enable = true;
    bindsTo = [ "deluged.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      LISTEN_ADDRESS=localhost \
      LISTEN_PORT=9354 \
      PER_TORRENT_METRICS=1 \
      DELUGE_HOST=localhost \
      DELUGE_PORT=58846 \
      DELUGE_USER=localclient \
      DELUGE_PASSWORD=$(cat /var/lib/deluge-exporter/auth) \
      ${python-deluge-exporter}/bin/python ${inputs.deluge-exporter}/deluge_exporter.py
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8112 ];

  services.prometheus.scrapeConfigs = [{
    job_name = "deluge";
    static_configs = [{ targets = [ "localhost:9354" ]; }];
  }];
}
