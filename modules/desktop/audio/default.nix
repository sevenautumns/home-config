{ pkgs, config, ... }: {
  imports = [ ./easyeffects ./cmus ./hotkeys ];

  services.playerctld.enable = true;
  home.packages = with pkgs; [ pulseaudio playerctl pavucontrol helvum ];
}
