{ pkgs, ... }: {
  services.sonarr = {
    enable = true;
    user = "autumnal";
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "autumnal";
    openFirewall = true;
  };
  services.bazarr = {
    enable = true;
    user = "autumnal";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
}
