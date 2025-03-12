{
  pkgs,
  config,
  lib,
  machine,
  ...
}:
let
  host = machine.host;
  theme = config.theme;
in
{
  programs.kitty = {
    enable = true;
    package = with pkgs; stable.kitty;
    theme = "Nord";

    settings = {
      window_padding_width = 2;
      # background_opacity = "0.9";
    };
  };
}
