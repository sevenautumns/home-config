{ pkgs, lib, config, ... }:
let
  nord0 = "#2e3440";
  nord1 = "#3b4252";
  nord2 = "#434c5e";
  nord3 = "#4c566a";
  nord4 = "#d8dee9";
  nord5 = "#e5e0f0";
  nord6 = "#eceff4";
  nord7 = "#8fbcbb";
  nord8 = "#88c0d0";
  nord9 = "#81a1c1";
  nord10 = "#5e81ac";
  nord11 = "#bf616a";
  nord12 = "#d08770";
  nord13 = "#ebcb8b";
  nord14 = "#a3be8c";
  nord14_sat = "#a0e565";
  nord15 = "#b48ead";
in {
  xdg.configFile."i3/scripts/empris.py".source = ./empris.py;

  services.network-manager-applet.enable = true;

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager = {
      i3 = let
        modifier = config.xsession.windowManager.i3.config.modifier;
        ws1 = "1";
        ws2 = "2";
        ws3 = "3";
        ws4 = "4";
        ws5 = "5";
        ws6 = "6";
        ws7 = "7";
        ws8 = "8";
        ws9 = "9";
        ws10 = "10";
        transparent = "#00000000";
      in {
        enable = true;
        package = pkgs.i3-gaps;
        config = {
          terminal = "alacritty";
          startup = [
            {
              # Set Background Images
              command = "${pkgs.betterlockscreen}/bin/betterlockscreen -w";
              always = true;
              notification = false;
            }
            {
              # Polybar sometimes starts faster than i3, 
              # resulting in the i3-module not activating
              command = "systemctl --user restart polybar.service";
              always = true;
              notification = false;
            }
            #{
            #  # Disable Caps
            #  command =
            #    "${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:ctrl_modifier";
            #  always = true;
            #  notification = false;
            #}
          ];
          bars = [ ];
          window.border = 1;
          gaps = {
            inner = 12;
            outer = 0;
            smartBorders = "no_gaps";
          };
          fonts = {
            names = [ "Roboto" ];
            size = 10.0;
          };
          modifier = "Mod4";
          keybindings = pkgs.lib.mkOptionDefault {
            # Open Applications
            "${modifier}+Return" = "exec --no-startup-id alacritty";
            "${modifier}+w" = "exec --no-startup-id ${pkgs.brave}/bin/brave";
            "${modifier}+Shift+Return" =
              "exec --no-startup-id ${pkgs.gnome.nautilus}/bin/nautilus --new-window";

            # Dmenu
            "${modifier}+d" =
              "exec --no-startup-id rofi -no-lazy-grab -show drun -modi drun";

            # Container Layout
            "${modifier}+s" = "layout stacking";
            "${modifier}+y" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+h" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+c" = "kill";

            #"${modifier}+l" = "exec --no-startup-id ${pkgs.betterlockscreen}/bin/betterlockscreen -l blur";

            # Volume Control
            "XF86AudioRaiseVolume" = ''
              exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -i 5 && ${pkgs.dunst}/bin/dunstify -u low \
                "Volume: `${pkgs.pamixer}/bin/pamixer --get-volume`%" \
                -h string:x-canonical-private-synchronous:volume \
                -h int:value:"`${pkgs.pamixer}/bin/pamixer --get-volume`"
            '';
            "XF86AudioLowerVolume" = ''
              exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -d 5 && ${pkgs.dunst}/bin/dunstify -u low \
                "Volume: `${pkgs.pamixer}/bin/pamixer --get-volume`%" \
                -h string:x-canonical-private-synchronous:volume \
                -h int:value:"`${pkgs.pamixer}/bin/pamixer --get-volume`"
            '';
            "XF86AudioMute" = ''
              exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -t && ${pkgs.dunst}/bin/dunstify -u low \
                "Mute: `${pkgs.pamixer}/bin/pamixer --get-mute`" \
                -h string:x-canonical-private-synchronous:volume \
                -h int:value:"`${pkgs.pamixer}/bin/pamixer --get-volume`"
            '';
            "XF86AudioMicMute" =
              "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            # Audio Controll
            "XF86AudioPlay" =
              "exec --no-startup-id ${pkgs.python3}/bin/python3 ~/.config/i3/scripts/empris.py playpause";
            "XF86AudioPause" =
              "exec --no-startup-id ${pkgs.python3}/bin/python3 ~/.config/i3/scripts/empris.py playpause";
            "XF86AudioNext" =
              "exec --no-startup-id ${pkgs.python3}/bin/python3 ~/.config/i3/scripts/empris.py next";
            "XF86AudioPrev" =
              "exec --no-startup-id ${pkgs.python3}/bin/python3 ~/.config/i3/scripts/empris.py prev";

            # Brightnessctl
            "XF86MonBrightnessUp" = ''
              exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +10% && ${pkgs.dunst}/bin/dunstify -u low \
                "Brightness: `${pkgs.brightnessctl}/bin/brightnessctl -m info | grep -oP '\d+(?=%)'`%" \
                -h string:x-canonical-private-synchronous:volume \
                -h int:value:"`${pkgs.brightnessctl}/bin/brightnessctl -m info | grep -oP '\d+(?=%)'`"
            '';
            "XF86MonBrightnessDown" = ''
              exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 10%- && ${pkgs.dunst}/bin/dunstify -u low \
                "Brightness: `${pkgs.brightnessctl}/bin/brightnessctl -m info | grep -oP '\d+(?=%)'`%" \
                -h string:x-canonical-private-synchronous:volume \
                -h int:value:"`${pkgs.brightnessctl}/bin/brightnessctl -m info | grep -oP '\d+(?=%)'`"
            '';

            # Calculator
            "XF86Calculator" =
              "exec --no-startup-id rofi -show calc -mode calc";
          };
          keycodebindings = {
            # Workspace select numpad
            "${modifier}+87" = "workspace ${ws1}";
            "${modifier}+88" = "workspace ${ws2}";
            "${modifier}+89" = "workspace ${ws3}";
            "${modifier}+83" = "workspace ${ws4}";
            "${modifier}+84" = "workspace ${ws5}";
            "${modifier}+85" = "workspace ${ws6}";
            "${modifier}+79" = "workspace ${ws7}";
            "${modifier}+80" = "workspace ${ws8}";
            "${modifier}+81" = "workspace ${ws9}";
            "${modifier}+90" = "workspace ${ws10}";
            # Workspace select numpad + numlock
            "${modifier}+Mod2+87" = "workspace ${ws1}";
            "${modifier}+Mod2+88" = "workspace ${ws2}";
            "${modifier}+Mod2+89" = "workspace ${ws3}";
            "${modifier}+Mod2+83" = "workspace ${ws4}";
            "${modifier}+Mod2+84" = "workspace ${ws5}";
            "${modifier}+Mod2+85" = "workspace ${ws6}";
            "${modifier}+Mod2+79" = "workspace ${ws7}";
            "${modifier}+Mod2+80" = "workspace ${ws8}";
            "${modifier}+Mod2+81" = "workspace ${ws9}";
            "${modifier}+Mod2+90" = "workspace ${ws10}";
            # move container to workspace with numpad
            "${modifier}+Shift+87" = "move container to workspace ${ws1}";
            "${modifier}+Shift+88" = "move container to workspace ${ws2}";
            "${modifier}+Shift+89" = "move container to workspace ${ws3}";
            "${modifier}+Shift+83" = "move container to workspace ${ws4}";
            "${modifier}+Shift+84" = "move container to workspace ${ws5}";
            "${modifier}+Shift+85" = "move container to workspace ${ws6}";
            "${modifier}+Shift+79" = "move container to workspace ${ws7}";
            "${modifier}+Shift+80" = "move container to workspace ${ws8}";
            "${modifier}+Shift+81" = "move container to workspace ${ws9}";
            "${modifier}+Shift+90" = "move container to workspace ${ws10}";
            # move container to workspace with numpad + numlock
            "${modifier}+Shift+Mod2+87" = "move container to workspace ${ws1}";
            "${modifier}+Shift+Mod2+88" = "move container to workspace ${ws2}";
            "${modifier}+Shift+Mod2+89" = "move container to workspace ${ws3}";
            "${modifier}+Shift+Mod2+83" = "move container to workspace ${ws4}";
            "${modifier}+Shift+Mod2+84" = "move container to workspace ${ws5}";
            "${modifier}+Shift+Mod2+85" = "move container to workspace ${ws6}";
            "${modifier}+Shift+Mod2+79" = "move container to workspace ${ws7}";
            "${modifier}+Shift+Mod2+80" = "move container to workspace ${ws8}";
            "${modifier}+Shift+Mod2+81" = "move container to workspace ${ws9}";
            "${modifier}+Shift+Mod2+90" = "move container to workspace ${ws10}";
          };
          workspaceOutputAssign = [
            {
              workspace = "1";
              output = "primary";
            }
            {
              workspace = "2";
              output = "primary";
            }
            {
              workspace = "3";
              output = "primary";
            }
            {
              workspace = "4";
              output = "primary";
            }
            {
              workspace = "5";
              output = "primary";
            }
            {
              workspace = "6";
              output = "primary";
            }
            {
              workspace = "7";
              output = "HDMI-0 HDMI-1 DP-0";
            }
            {
              workspace = "8";
              output = "HDMI-0 HDMI-1 DP-0";
            }
            {
              workspace = "9";
              output = "HDMI-0 HDMI-1 DP-0";
            }
            {
              workspace = "10";
              output = "HDMI-0 HDMI-1 DP-0";
            }
          ];

          colors = {
            focused = {
              background = nord0;
              text = nord6;
              border = nord6;
              childBorder = nord4;
              indicator = nord14_sat;
            };
            unfocused = {
              background = nord0;
              text = nord5;
              border = nord0;
              childBorder = nord2;
              indicator = nord14_sat;
            };
            focusedInactive = {
              background = nord0;
              text = nord5;
              border = nord0;
              childBorder = nord0;
              indicator = nord14_sat;
            };
            urgent = {
              background = nord11;
              text = nord6;
              border = nord11;
              childBorder = nord12;
              indicator = nord14_sat;
            };
          };
        };
      };
    };
  };
}
