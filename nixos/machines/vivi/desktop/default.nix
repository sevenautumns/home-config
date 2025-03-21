{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # ./greetd.nix
    ./pipewire.nix
    ./virtualbox.nix
  ];

  # Required for various programs
  programs.dconf.enable = true;

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.polkit.enable = true;

  hardware.xone.enable = true;

  # Insecure because of old dotnet version
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.package = pkgs.unstable.opentabletdriver;
  hardware.opentabletdriver.daemon.enable = true;
}
