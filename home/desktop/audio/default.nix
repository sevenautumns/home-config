{ pkgs, config, ... }: {
  home.packages = with pkgs; [ pulseaudio playerctl pavucontrol stable.helvum ];
}
