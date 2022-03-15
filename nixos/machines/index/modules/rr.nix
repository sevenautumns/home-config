{ pkgs, ... }: {
  services.jackett = {
    enable = true;
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    user = "autumnal";
    openFirewall = true;
  };
  #services.radarr = {
  #    enable = true;
  #    user = "autumnal";
  #    openFirewall = true;
  #};
  #services.bazarr = {
  #    enable = true;
  #    user = "autumnal";
  #    openFirewall = true;
  #};
}
