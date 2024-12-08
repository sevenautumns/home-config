{ pkgs, ... }: {
  services.sonarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.bazarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.homepage-dashboard = {
    enable = true;
  };
}
