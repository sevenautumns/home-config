{ config, lib, pkgs, modulesPath, ... }: {

  home.packages = with pkgs; [ lutris winetricks stable.wine kdialog ];
}

