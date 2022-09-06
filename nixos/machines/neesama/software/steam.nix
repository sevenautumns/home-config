{ config, lib, pkgs, modulesPath, ... }: {
  programs.steam.enable = true;

  services.flatpak.enable = true;

  #  environment.systemPackages = with pkgs; [
  #  steam
  #];
}

