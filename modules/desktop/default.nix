{ pkgs, config, ... }: {
  imports = [
    ./audio
    ./font.nix
    ./polybar
    ./i3
    ./picom.nix
    ./dunst.nix
    ./redshift.nix
    ./software.nix
    ./gtk.nix
    ./fcitx
    ./rofi
  ];

  home.packages = with pkgs; [
    # i3 polybar
    gcc
    calc
    pywal
  ];

  #services.betterlockscreen.enable = true;
}
