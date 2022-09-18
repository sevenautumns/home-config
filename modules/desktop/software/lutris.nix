{ config, lib, pkgs, modulesPath, ... }: {

  home.packages = with pkgs; [
    lutris

    #Genshin requirements
    xdelta
    xterm
    zenith
  ];
}

