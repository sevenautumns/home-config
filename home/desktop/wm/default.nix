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
    fuzzel
    wdisplays
    xdg-terminal-exec-mkhl
    dmenu-wayland
    ironbar
    xwayland
    xdg-utils
  ];

}
