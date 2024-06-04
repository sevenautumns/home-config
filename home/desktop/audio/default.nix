{ pkgs, lib, config, machine, ... }: {
  home.packages = with pkgs; [ pulseaudio playerctl ] ++ lib.optionals machine.nixos [ pavucontrol stable.helvum ];
}
