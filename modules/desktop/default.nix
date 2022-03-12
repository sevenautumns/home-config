{ pkgs, config, lib, ... }:
let headless = config.machine.headless;
in {
  imports = [
    ./windowManager
    ./software
    ./audio

    ./font.nix
    ./gtk.nix
  ];
}
