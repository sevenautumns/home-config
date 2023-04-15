{ pkgs, config, lib, ... }: {
  imports = [
    ./gnome
    ./software
    ./audio
    # ./wm

    ./mime.nix
    ./font.nix
    ./gtk.nix
  ];

  # Gnome gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gnome.gvfs}/lib/gio/modules";
  };
}
