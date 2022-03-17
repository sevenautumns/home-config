{ pkgs, config, ... }: {
  services.syncplay = {
    enable = true;
    port = 8999;
    certDir = "/var/lib/acme/autumnal.de";
  };
  users.users.syncplay.extraGroups = [ "nginx" "acme" ];

  networking.firewall.allowedTCPPorts = [ config.services.syncplay.port ];

  services.nginx.virtualHosts = {
    "autumnal.de" = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    certs = {
      "autumnal.de" = {
        postRun = ''
          cp key.pem privkey.pem
          systemctl restart syncplay.service
        '';
      };
    };
  };
}
