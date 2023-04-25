{ pkgs, config, lib, ... }: {
  services.mako = with config.theme; {
    enable = true;
    font = "Ttyp0 10";
    backgroundColor = gray0;
    borderColor = brown;
    textColor = brown;
  };
}
