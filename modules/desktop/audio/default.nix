{ pkgs, config, ... }: {
  imports = [ ./easyeffects ./cmus ];

  services.playerctld.enable = true;
  home.packages = with pkgs; [ pulseaudio playerctl pavucontrol ];
}
