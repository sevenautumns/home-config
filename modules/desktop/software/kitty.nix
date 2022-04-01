{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
  theme = config.theme;
in {
  programs.kitty = {
    enable = true;
    package = with pkgs; fixGL unstable.kitty;
    theme = "Nord";
    font.name = "Dina";
    #font.size = if host == "neesama" then 11 else 8;

    settings = {
      window_padding_width = 5;
      background_opacity = "0.9";
    };
  };
}