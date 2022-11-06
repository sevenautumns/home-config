{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ./greetd.nix ./pipewire.nix ];

  # Required for various programs
  programs.dconf.enable = true;

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  hardware.xone.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
}
