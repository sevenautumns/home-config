{ pkgs, config, host, ... }:
let
  nord0 = "#2e3440";
  nord1 = "#3b4252";
  nord2 = "#434c5e";
  nord3 = "#4c566a";
  nord4 = "#d8dee9";
  nord5 = "#e5e0f0";
  nord6 = "#eceff4";
  nord7 = "#8fbcbb";
  nord8 = "#88c0d0";
  nord9 = "#81a1c1";
  nord10 = "#5e81ac";
  nord11 = "#bf616a";
  nord12 = "#d08770";
  nord13 = "#ebcb8b";
  nord14 = "#a3be8c";
  nord15 = "#b48ead";
in {
  home.packages = lib.optional (host == "ft-ssy-sfnb") pkgs.alacritty;

  # Alacritty doesnt work yet with homemanager.
  programs.alacritty = {
    enable = true;

    # https://github.com/NixOS/nixpkgs/issues/80702
    package = if host == "ft-ssy-sfnb" then pkgs.alacritty else pkgs.hello;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 0.9;
      };
      font.size = if host == "neesama" then 11 else 8;
      shell.program = pkgs.fish;
      colors = {
        primary = {
          background = nord0;
          foreground = nord4;
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = nord0;
          cursor = nord4;
        };
        vi_mode_cursor = {
          text = nord0;
          cursor = nord4;
        };
        selection = {
          text = "CellForeground";
          background = nord3;
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = nord8;
          };
          bar = {
            background = nord2;
            foreground = nord4;
          };
        };
        normal = {
          black = nord1;
          red = nord11;
          green = nord14;
          yellow = nord13;
          blue = nord9;
          magenta = nord15;
          cyan = nord8;
          white = "#e5e9f0";
        };
        bright = {
          black = nord3;
          red = nord11;
          green = nord14;
          yellow = nord13;
          blue = nord9;
          magenta = nord15;
          cyan = nord7;
          white = nord6;
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };
}
