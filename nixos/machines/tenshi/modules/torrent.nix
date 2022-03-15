{ pkgs, ... }: {
  virtualisation.oci-containers = {
    containers = {
      transmission = {
        image = "ghcr.io/linuxserver/transmission:latest";
        user = "1000:1000";
        environment = {
          WEBUI_PORT = "9091";
          PUID = "1000";
          PGID = "1000";
          TZ = "Europe/Berlin";
          TRANSMISSION_WEB_HOME = "/flood-for-transmission/";
        };
        volumes = [
          "/var/lib/transmission/data:/data"
          "/var/lib/transmission/config:/config"
        ];
        extraOptions = [ "--net=container:nordvpn" ];
        dependsOn = [ "nordvpn" ];
      };
      nordvpn = {
        ports = [ "9091:9091" ];
        image = "ghcr.io/bubuntux/nordlynx:latest";
        environment.NET_LOCAL = "192.145.45.214/32";
        environmentFiles = [ "/var/lib/nordvpn/pass" ];
        extraOptions = [ "--cap-add=NET_ADMIN" ];
      };
    };
  };

  services.nginx.virtualHosts = {
    "torrent.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      basicAuthFile = "/var/lib/transmission/basicauth";
      locations."/".proxyPass = "http://127.0.0.1:9091";
    };
  };
}
