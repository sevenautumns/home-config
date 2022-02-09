{ config, pkgs, lib, ... }: {
  imports = [ modules/desktop modules/shell ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  #xdg.configFile."test".text = "{config.}";

  home.packages = [
    pkgs.alacritty
    pkgs.unstable.xterm
    pkgs.nixfmt
    pkgs.bitwarden
    pkgs.neofetch
  ];
}
