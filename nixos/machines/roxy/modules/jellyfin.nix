{ pkgs, inputs, ... }: {
  services.jellyfin = {
    enable = false;
    user = "autumnal";
    openFirewall = true;
  };
}
