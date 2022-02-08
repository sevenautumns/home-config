{ pkgs, config, ... }: {
  imports = [ ./easyeffects ./cmus ];

  services.playerctld.enable = true;
  home.packages = [ pkgs.pulseaudio pkgs.playerctl ];
}
