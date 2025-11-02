{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./sway.nix
    ./mako.nix
  ];

  services.kanshi.enable = true;

  home.packages = with pkgs; [
    niri
    waybar
    xwayland-satellite
    wdisplays
    xdg-terminal-exec-mkhl
    dmenu-wayland
    ironbar
    xwayland
    xdg-utils
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "94e2d5ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "94e2d5ff";
        counter = "7f849cff";
        border = "94e2d5ff";
      };
    };
  };
}
