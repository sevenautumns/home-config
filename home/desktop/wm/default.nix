{ pkgs, config, lib, ... }: {
  imports = [
    ./sway.nix
    ./mako.nix
  ];
}
