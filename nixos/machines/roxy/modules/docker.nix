{ pkgs, ... }:
{
  #environment.systemPackages = with pkgs; [ docker-compose ];
  #virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  networking.firewall.allowedTCPPorts = [
    # 8080
    # 8443
  ];
  networking.firewall.allowedUDPPorts = [
    # 3478
    # 10001
  ];

  # systemd.tmpfiles.rules =
  #   [ "d '/var/lib/unifi' 0700 autumnal users - -" ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      # ds3os = {
      #   image = "timleonarduk/ds3os:latest";
      #   volumes = [ "/var/lib/ds3os:/opt/ds3os/Saved" ];
      #   environment = {
      #     TZ = "Europe/Berlin";
      #     PUID = "1000";
      #     PGID = "1000";
      #   };
      #   extraOptions = [ "--network=host" ];
      #   ports = [ "1000:1000" ];
      # };
      palworld = {
        image = "jammsen/palworld-dedicated-server:latest";
        volumes = [ "/var/lib/palworld:/config" ];
        environment = {
          TZ = "Europe/Berlin";
          PUID = "1000";
          PGID = "1000";
        };
        ports = [
          "8211:8211"
        ];
      };
      # unifi = {
      #   image = "lscr.io/linuxserver/unifi-network-application:latest";
      #   volumes = [ "/var/lib/unifi:/config" ];
      #   environment = {
      #     TZ = "Europe/Berlin";
      #     PUID = "1000";
      #     PGID = "1000";
      #   };
      #   ports = [
      #     "8443:8443"
      #     "3478:3478/udp"
      #     "10001:10001/udp"
      #     "8080:8080"
      #   ];
      # };
      #portainer = {
      #  image = "portainer/portainer-ce:latest";
      #  volumes = [
      #    "/var/lib/portainer:/data"
      #    "/var/run/docker.sock:/var/run/docker.sock"
      #  ];
      #  ports = [ "8000:8000" "9000:9000" ];
      #};
      # heimdall = {
      #   image = "ghcr.io/linuxserver/heimdall:latest";
      #   volumes = [ "/var/lib/heimdall:/config" ];
      #   environment = {
      #     TZ = "Europe/Berlin";
      #     PUID = "1000";
      #     PGID = "1000";
      #   };
      #   extraOptions = [ "--cpus = 0.5 " ];
      #   ports = [ " 80:80" ];
      # };
    };
  };
}
