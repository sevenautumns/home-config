{ pkgs, config, lib, ... }: {
  imports = [
    # ./gnome
    ./i3
    ./software
    ./audio

    ./mime.nix
    ./font.nix
    ./gtk.nix
  ];

  # Gnome gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gnome.gvfs}/lib/gio/modules";
  };
}
