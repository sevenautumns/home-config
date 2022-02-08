{ pkgs, config, ... }: {
  imports = [
    ./audio
    ./font.nix
    ./polybar
    ./i3
    ./picom.nix
    ./dunst.nix
    ./redshift.nix
    ./gtk.nix
    ./fcitx
  ];

  home.packages = with pkgs; [
    # i3 polybar
    gcc
    calc
    pywal
    rofi
    betterlockscreen
  ];
}
