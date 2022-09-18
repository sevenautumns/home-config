{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ./gdm.nix ./pipewire.nix ];

  hardware.xone.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
}
