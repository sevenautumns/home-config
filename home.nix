{ config, pkgs, lib, host, ... }: {
    imports = [ modules/desktop modules/shell modules/theme.nix ];

    programs.home-manager.enable = true;
    nixpkgs.config.allowUnfree = true;

    #xdg.configFile."test".text = "${config.theme.nord0}";
    xdg.enable = true;

    home.packages = [
      #pkgs.alacritty
      pkgs.unstable.xterm
      pkgs.glibc
    ];
}
