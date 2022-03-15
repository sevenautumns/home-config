{ pkgs, ... }: {

  networking.firewall.allowedTCPPorts = [ 9091 ];

  virtualisation.oci-containers = {
    containers = {
      transmission = {
        image = "ghcr.io/linuxserver/transmission:latest";
        environment = {
          WEBUI_PORT = "9091";
          PUID = "1000";
          PGID = "1000";
          USER = "admin";
          TZ = "Europe/Berlin";
          TRANSMISSION_WEB_HOME = "/flood-for-transmission/";
        };
        environmentFiles = [ "/var/lib/transmission/pass" ];
        volumes = [
          "/media/torrent_storage/completed:/data/completed"
          "/media/torrent_storage/incomplete:/data/incomplete"
          "/var/lib/transmission/config:/config"
        ];
        extraOptions = [ "--net=container:nordvpn" ];
        dependsOn = [ "nordvpn" ];
      };
      nordvpn = {
        ports = [ "9091:9091" ];
        image = "ghcr.io/bubuntux/nordlynx:latest";
        environment.NET_LOCAL = "10.0.0.0/13";
        environmentFiles = [ "/var/lib/nordvpn/pass" ];
        extraOptions = [ "--cap-add=NET_ADMIN" ];
      };
      transmission_exporter = {
        image = "micaelserrano/transmission-exporter:latest";
        environment = {
          TRANSMISSION_ADDR = "http://10.4.0.0:9091";
          TRANSMISSION_USERNAME = "admin";
        };
        environmentFiles = [ "/var/lib/transmission_exporter/pass" ];
        extraOptions = [ "--cpus=0.5" ];
        ports = [ "19091:19091" ];
      };
    };
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "transmission";
    static_configs = [{ targets = [ "localhost:19091" ]; }];
  }];
}
