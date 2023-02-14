{ config, lib, pkgs, modulesPath, ... }: {
  virtualisation.virtualbox.host = {
    # enable = true;
    # package = pkgs.stable.virtualbox;
    enableExtensionPack = true;
    # guest.enable = true;
    # guest.x11 = true;
  };
}
