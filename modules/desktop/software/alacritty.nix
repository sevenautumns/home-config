{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
  theme = config.theme;
in {
  # services.sxhkd.keybindings = { "super + Return" = "alacritty"; };

  programs.alacritty = {
    enable = true;
    package = with pkgs; if machine.nixos then unstable.alacritty else hello;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 1;
        gtk_theme_variant = "dark";
      };
      font.size = if host == "neesama" then 11 else 8;
      shell.program = "${pkgs.fish}/bin/fish";
      colors = { 
        transparent_background_colors = true; 
        primary = {
          background = "#292929";
          foreground = "#F3F2CC";
        };
        normal = {
          black = "#292929";
          red = "#F05E48";
          green = "#8DAF67";
          yellow = "#FAD566";
          cyan = "#86C1B9";
          white = "#F3F2CC";
        };
        bright = {
          black = "#3A3A3A";
          red = "#F16B57";
          green = "#96B573";
          yellow = "#FAD872";
          cyan = "#90C6BF";
          white = "#E8E8E8";
        };
        dim = {
          black = "#262626";
          red = "#DD5642";
          green = "#82A15F";
          yellow = "#E6C45E";
          cyan = "#7BB2AA";
          white = "#AAAAAA";
        };
      };
    };
  };
}
