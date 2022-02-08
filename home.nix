{ config, pkgs, lib, ... }: {
  imports = [ modules/desktop modules/shell ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = [ pkgs.xterm pkgs.nixfmt pkgs.bitwarden pkgs.neofetch ];
}
