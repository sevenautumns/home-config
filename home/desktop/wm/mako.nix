{
  pkgs,
  config,
  machine,
  lib,
  ...
}:
{
  services.mako = with config.theme; {
    enable = true;
    package = with pkgs; if machine.nixos then mako else hello;
    settings = {
      border-color = brown;
      text-color = brown;
      background-color = gray0;
      font = "Ttyp0 10";
    };
  };
}
