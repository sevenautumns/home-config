{ config, pkgs, lib, host, ... }: {
  imports = [ modules/desktop modules/shell ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  #xdg.configFile."test".text = "{config.}";
  xdg.enable = true;

  home.packages = [
    #pkgs.alacritty
    pkgs.unstable.xterm
    pkgs.glibc
  ];
}
