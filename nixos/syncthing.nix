{ pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "autumnal";
      configDir = "/home/autumnal/.config/syncthing";
    };
  };
}
