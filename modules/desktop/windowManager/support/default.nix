{ pkgs, config, ... }: {
  imports =
    [ ./betterlockscreen.nix ./dunst.nix ./picom.nix ./polybar.nix ./rofi.nix ];
}
