{ pkgs, config, ... }: {

  xdg.configFile."audio/empris.py".source = ./empris.py;

  services.sxhkd.keybindings = {
    "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = ''
      ${pkgs.pamixer}/bin/pamixer -{i,d} 5 && \
        ${pkgs.bash}/bin/bash -c '${pkgs.dunst}/bin/dunstify -u low \
        "Volume: $(${pkgs.pamixer}/bin/pamixer --get-volume)%" \
        -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$(${pkgs.pamixer}/bin/pamixer --get-volume)"'
    '';
    "XF86AudioMute" = ''
      ${pkgs.pamixer}/bin/pamixer -t && \
        ${pkgs.bash}/bin/bash -c '${pkgs.dunst}/bin/dunstify -u low \
        "Mute: $(${pkgs.pamixer}/bin/pamixer --get-mute)" \
        -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$(${pkgs.pamixer}/bin/pamixer --get-volume)"'
    '';
    "XF86AudioMicMute" =
      "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

    # Audio Controll
    "{XF86AudioPlay,XF86AudioPause,XF86AudioNext,XF86AudioPrev}" =
      "${pkgs.python3}/bin/python3 ~/.config/audio/empris.py {playpause,playpause,next,prev}";

    # Brightnessctl
    "{XF86MonBrightnessUp,XF86MonBrightnessDown}" = ''
      ${pkgs.brightnessctl}/bin/brightnessctl set {+10%,10%-} && \
        ${pkgs.bash}/bin/bash -c ' \
        export BRIGHT=$(${pkgs.brightnessctl}/bin/brightnessctl -m info| grep -oP "\d+(?=%)"); \
        ${pkgs.dunst}/bin/dunstify -u low "Brightness: $(echo $BRIGHT)%" \
        -h string:x-canonical-private-synchronous:volume -h int:value:"$(echo $BRIGHT)"'
    '';
  };
}
