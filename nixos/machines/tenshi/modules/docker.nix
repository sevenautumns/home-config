{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ docker-compose ];
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        volumes = [
          "/var/lib/portainer:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        ports = [ "8000:8000" "9000:9000" ];
      };
    };
  };

  services.nginx.virtualHosts = {
    "docker.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:9000";
    };
  };
}
