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

  home.packages = with pkgs; [
    niri
    fuzzel
    wdisplays
    xdg-terminal-exec-mkhl
    dmenu-wayland
    ironbar
    xdg-utils
  ];

}
