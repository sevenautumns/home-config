{ pkgs, ... }: {
  virtualisation.oci-containers = {
    containers = {
      lavalink = {
        image = "fredboat/lavalink:master";
        user = "1000:1000";
        volumes = [
          "/var/lib/lavalink/application.yml:/opt/Lavalink/application.yml"
        ];
        ports = [ "2333:2333" ];
      };
    };
  };

  age.secrets.lavalink = {
    file = ../../../../secrets/lavalink.age;
    path = "/var/lib/lavalink/application.yml";
    owner = "autumnal";
  };
}
