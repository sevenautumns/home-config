{ pkgs, ... }: {
  #environment.systemPackages = with pkgs; [ docker-compose ];
  #virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    #9000 
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      #portainer = {
      #  image = "portainer/portainer-ce:latest";
      #  volumes = [
      #    "/var/lib/portainer:/data"
      #    "/var/run/docker.sock:/var/run/docker.sock"
      #  ];
      #  ports = [ "8000:8000" "9000:9000" ];
      #};
      heimdall = {
        image = "ghcr.io/linuxserver/heimdall:latest";
        volumes = [ "/var/lib/heimdall:/config" ];
        environment = {
          TZ = "Europe/Berlin";
          PUID = "1000";
          PGID = "1000";
        };
        extraOptions = [ "--cpus=0.5" ];
        ports = [ "80:80" ];
      };
    };
  };
}
