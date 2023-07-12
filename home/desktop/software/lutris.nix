{ config, lib, pkgs, modulesPath, ... }: {

  home.packages = with pkgs; [ lutris winetricks wine kdialog ];
}

