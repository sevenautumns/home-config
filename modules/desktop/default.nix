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
    betterlockscreen
    feh
  ];

  # Fix Nautilus gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = [ "${pkgs.gnome.gvfs}/lib/gio/modules" ];
  };

  #services.betterlockscreen.enable = true;
}
