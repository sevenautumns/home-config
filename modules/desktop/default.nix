{ pkgs, config, lib, ... }: {
  imports = [
    ./gnome
    ./software
    ./audio

    ./font.nix
    ./gtk.nix
  ];
}
