{ pkgs, config, lib, ... }: {
  imports = [
    # ./i3.nix
    ./herbst.nix
    ./rofi.nix
    ./redshift.nix
    ./picom.nix
  ];
}
