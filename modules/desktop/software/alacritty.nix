{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
  theme = config.theme;
in {
  services.sxhkd.keybindings = { "super + Return" = "alacritty"; };

  programs.alacritty = {
    enable = true;
    package = with pkgs; if machine.nixos then unstable.alacritty else hello;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        opacity = 0.9;
        gtk_theme_variant = "dark";
      };
      font.size = if host == "neesama" then 11 else 8;
      shell.program = "${pkgs.fish}/bin/fish";
      colors = { transparent_background_colors = true; };
    };
  };
}
