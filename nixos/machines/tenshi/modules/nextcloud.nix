{ pkgs, ... }: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    hostName = "cloud.autumnal.de";
    https = true;
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "05:00:00";
    config = {
      adminuser = "autumnal";
      adminpassFile = "/var/lib/nextcloud/adminpassfile";
    };
  };

  age.secrets.nextcloud_adminpass = {
    file = ../../../../secrets/nextcloud_adminpass.age;
    path = "/var/lib/nextcloud/adminpassfile";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nginx.virtualHosts = {
    "cloud.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
