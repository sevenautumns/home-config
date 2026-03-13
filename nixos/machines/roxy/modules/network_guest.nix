{
  pkgs,
  lib,
  config,
  flakeRoot,
  ...
}:
{
  networking = {
    networkmanager.enable = lib.mkForce true;
    firewall.enable = lib.mkForce true;
  };
}
