{ pkgs, ... }: {
  virtualisation.oci-containers = {
    containers = {
      lavalink = {
        image = "fredboat/lavalink:master";
        user = "1000:1000";
        volumes =
          [ "/var/lib/lavalink/application.yml:/opt/Lavalink/application.yml" ];
        ports = [ "2333:2333" ];
      };
    };
  };

  age.secrets.lavalink = {
    file = ../../../../../secrets/lavalink.age;
    path = "/var/lib/lavalink/application.yml";
    owner = "autumnal";
  };

  services.nginx.virtualHosts = {
    "lavalink.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:2333";
        extraConfig =
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;";
      };
    };
  };
}
