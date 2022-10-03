{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ syncthing ];
  services = {
    syncthing = {
      enable = true;
      user = "autumnal";
      configDir = "/home/autumnal/.config/syncthing";
    };
  };
}
