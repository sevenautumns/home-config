{ pkgs, config, machine, lib, ... }: {
  services.mako = with config.theme; {
    enable = true;
    package = with pkgs; if machine.nixos then mako else hello;
    font = "Ttyp0 10";
    backgroundColor = gray0;
    borderColor = brown;
    textColor = brown;
  };
}
