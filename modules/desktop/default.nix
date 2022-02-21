{ pkgs, config, ... }: {
  imports = [
    ./windowManager
    ./software
    ./audio

    ./font.nix
    ./gtk.nix
  ];
}
