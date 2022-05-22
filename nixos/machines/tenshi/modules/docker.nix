{ pkgs, ... }: {
  #environment.systemPackages = with pkgs; [ docker-compose ];
  virtualisation.podman.enable = true;

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
      #ror2 = {
      #  image = "avivace/ror2server:latest";
      #  environment = {
      #    R2_HEARTBEAT = "1";
      #    R2_QUERY_PORT = "27000";
      #    R2_HOSTNAME = "Autumnal";
      #    R2_PSW = "secret";
      #  };
      #  ports = [ "27000:27000/udp" "27015:27015/udp" ];
      #  extraOptions = [ "--cpus=2.0" ];
      #};
    };
  };

  #services.nginx.virtualHosts = {
  #  "docker.autumnal.de" = {
  #    forceSSL = true;
  #    enableACME = true;
  #    locations."/".proxyPass = "http://127.0.0.1:9000";
  #  };
  #};
}
