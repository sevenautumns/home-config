{ pkgs, config, ... }: {
  imports = [ ./easyeffects ./cmus ./hotkeys.nix ];

  #services.playerctld.enable = true;
  home.packages = with pkgs; [ pulseaudio playerctl pavucontrol helvum ];
}
