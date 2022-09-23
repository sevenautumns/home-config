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
}
