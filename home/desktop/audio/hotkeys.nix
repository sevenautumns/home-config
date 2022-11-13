{ pkgs, config, ... }:
{
  #services.sxhkd.keybindings = {
  #  "{XF86AudioRaiseVolume,XF86AudioLowerVolume}" = ''
  #    ${pkgs.pamixer}/bin/pamixer -{i,d} 5 && \
  #      ${pkgs.bash}/bin/bash -c '${pkgs.dunst}/bin/dunstify -u low \
  #      "Volume: $(${pkgs.pamixer}/bin/pamixer --get-volume)%" \
  #      -h string:x-canonical-private-synchronous:volume \
  #      -h int:value:"$(${pkgs.pamixer}/bin/pamixer --get-volume)"'
  #  '';
  #  "XF86AudioMute" = ''
  #    ${pkgs.pamixer}/bin/pamixer -t && \
  #      ${pkgs.bash}/bin/bash -c '${pkgs.dunst}/bin/dunstify -u low \
  #      "Mute: $(${pkgs.pamixer}/bin/pamixer --get-mute)" \
  #      -h string:x-canonical-private-synchronous:volume \
  #      -h int:value:"$(${pkgs.pamixer}/bin/pamixer --get-volume)"'
  #  '';
  #  "XF86AudioMicMute" =
  #    "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

  #  # Brightnessctl
  #  "{XF86MonBrightnessUp,XF86MonBrightnessDown}" = ''
  #    ${pkgs.brightnessctl}/bin/brightnessctl set {+10%,10%-} && \
  #      ${pkgs.bash}/bin/bash -c ' \
  #      export BRIGHT=$(${pkgs.brightnessctl}/bin/brightnessctl -m info| grep -oP "\d+(?=%)"); \
  #      ${pkgs.dunst}/bin/dunstify -u low "Brightness: $(echo $BRIGHT)%" \
  #      -h string:x-canonical-private-synchronous:volume -h int:value:"$(echo $BRIGHT)"'
  #  '';
  #};
}
