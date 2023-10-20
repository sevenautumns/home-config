{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
  theme = config.theme;
in
{
  # services.sxhkd.keybindings = { "super + Return" = "alacritty"; };

  # Fallback Terminal
  home.packages = with pkgs;
    [
      (makeDesktopItem {
        name = "Alacritty (Fallback)";
        desktopName = "Alacritty (Fallback)";
        icon = "Alacritty";
        exec =
          "${config.programs.alacritty.package}/bin/alacritty --command fish --no-config";
        terminal = false;
        type = "Application";
      })
    ];

  programs.alacritty = {
    enable = true;
    package = with pkgs; if machine.nixos then unstable.alacritty else hello;
    settings = {
      env = { WINIT_X11_SCALE_FACTOR = "1"; };
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 0.95;
        # decorations_theme_variant = "dark";
      };
      font.size = 10;
      shell.program = "${pkgs.fish}/bin/fish";
      colors = {
        transparent_background_colors = true;
        # Autumn
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

        # Monokai Pro
        # primary = {
        #   background = "0x2D2A2E";
        #   foreground = "0xfff1f3";
        # };
        # normal = {
        #   black = "0x2c2525";
        #   red = "0xfd6883";
        #   green = "0xadda78";
        #   yellow = "0xf9cc6c";
        #   blue = "0xf38d70";
        #   magenta = "0xa8a9eb";
        #   cyan = "0x85dacc";
        #   white = "0xfff1f3";
        # };
        # bright = {
        #   black = "0x72696a";
        #   red = "0xfd6883";
        #   green = "0xadda78";
        #   yellow = "0xf9cc6c";
        #   blue = "0xf38d70";
        #   magenta = "0xa8a9eb";
        #   cyan = "0x85dacc";
        #   white = "0xfff1f3";
        # };

        # primary = {
        #   background = "0x282828";
        #   foreground = "0xebdbb2";
        # }; 
        # # Normal colors;
        # normal = {
        #   black = "0x282828";
        #   red = "0xcc241d";
        #   green = "0x98971a";
        #   yellow = "0xd79921";
        #   blue = "0x458588";
        #   magenta = "0xb16286";
        #   cyan = "0x689d6a";
        #   white = "0xebdbb2";
        # }; # Bright colors
        # bright = {
        #   black = "0x3c3836";
        #   red = "0xfb4934";
        #   green = "0xb8bb26";
        #   yellow = "0xfabd2f";
        #   blue = "0x83a598";
        #   magenta = "0xd3869b";
        #   cyan = "0x8ec07c";
        #   white = "0xfbf1c7";
        # };
      };
    };
  };
}
