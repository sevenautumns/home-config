{ pkgs, inputs, ... }: let
  lavalink = pkgs.fetchurl {
    url = "https://ci.fredboat.com/guestAuth/repository/download/Lavalink_Build/9388:id/Lavalink.jar";
    sha256 = "11nq06d131y4wmf3drm0yk502d2xc6n5qy82cg88rb9nqd2lj41k";
  };
in {
  systemd.services.lavalink = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "lavalink";
      ExecStart = "${pkgs.jre}/bin/java -jar ${lavalink}";
      Restart = "always";
      RestartSec = 2;
      WorkingDirectory = "/var/lib/lavalink";
    };
  };

  age.secrets.lavalink = {
    file = ../../../../secrets/lavalink.age;
    path = "/var/lib/lavalink/application.yml";
    owner = "lavalink";
  };

  users.users.lavalink = {
    description = "Lavalink service user";
    home = "/var/lib/lavalink";
    createHome = true;
    homeMode = "750";
    isSystemUser = true;
    group = "users";
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

  networking.firewall.allowedTCPPorts = [ 2333 ];
}
