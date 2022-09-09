{ pkgs, config, lib, ... }: {
  imports = [
    # ./gnome
    ./i3
    ./software
    ./audio

    ./font.nix
    ./gtk.nix
  ];
}
