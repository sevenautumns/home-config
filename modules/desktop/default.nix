{ pkgs, config, lib, ... }: {
  imports = [
    ./windowManager
    ./software
    ./audio

    ./font.nix
    ./gtk.nix
  ];
}
