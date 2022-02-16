{ pkgs, config, ... }: {
  imports = [
    ./audio
    ./font.nix
    ./polybar.nix
    ./i3
    ./picom.nix
    ./dunst.nix
    ./redshift.nix
    ./software.nix
    ./gtk.nix
    ./fcitx
    ./rofi.nix
    ./mpv.nix
    ./mime.nix
    ./autorandr.nix
    ./betterlockscreen.nix
  ];

  home.packages = with pkgs; [
    # i3 polybar
    gcc
    calc
    pywal
    feh
  ];

  xdg.desktopEntries = {
    screenshot = {
      name = "Screenshot";
      genericName = "Gnome Screenshot Tool";
      # Manually create desktop entry which calls this with --interactive
      exec =
        "${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot --interactive";
      terminal = false;
      categories = [ "Application" "Graphics" ];
      icon = "org.gnome.Screenshot";
    };
  };

  # Fix Nautilus gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = [ "${pkgs.gnome.gvfs}/lib/gio/modules" ];

    # help building locally compiled programs
    ##LIBRARY_PATH = "$HOME/.nix-profile/lib:/lib:/usr/lib";
    # header files
    ##CPATH = "$HOME/.nix-profile/include";
    ##C_INCLUDE_PATH = "$CPATH";
    ##CPLUS_INCLUDE_PATH = "$CPATH";
    # pkg-config
    ##PKG_CONFIG_PATH =
    ##  "$HOME/.nix-profile/lib/pkgconfig:$HOME/.nix-profile/share/pkgconfig";
  };
}
