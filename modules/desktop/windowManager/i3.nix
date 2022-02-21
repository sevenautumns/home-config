{ pkgs, lib, config, host, ... }:
let
  theme = config.theme;

  secondars-monitors = if host == "neesama" then
    "HDMI-0 HDMI-1 DP-0 DP-1 DP-3"
  else if host == "ft-ssy-sfnb" then
    "HDMI-1 DP-1 DP-2"
  else
    "";
in {
  xsession = {
    enable = true;
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
          startup = [{
            # Polybar sometimes starts faster than i3, 
            # resulting in the i3-module not activating
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }];
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
            "${modifier}+Shift+Return" = "exec --no-startup-id alacritty";

            # Container Layout
            "${modifier}+s" = "layout stacking";
            "${modifier}+y" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+h" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+c" = "kill";
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
              output = secondars-monitors;
            }
            {
              workspace = "8";
              output = secondars-monitors;
            }
            {
              workspace = "9";
              output = secondars-monitors;
            }
            {
              workspace = "10";
              output = secondars-monitors;
            }
          ];

          colors = {
            focused = {
              background = theme.nord0;
              text = theme.nord6;
              border = theme.nord6;
              childBorder = theme.nord4;
              indicator = theme.nord14_sat;
            };
            unfocused = {
              background = theme.nord0;
              text = theme.nord5;
              border = theme.nord0;
              childBorder = theme.nord2;
              indicator = theme.nord14_sat;
            };
            focusedInactive = {
              background = theme.nord0;
              text = theme.nord5;
              border = theme.nord0;
              childBorder = theme.nord0;
              indicator = theme.nord14_sat;
            };
            urgent = {
              background = theme.nord11;
              text = theme.nord6;
              border = theme.nord11;
              childBorder = theme.nord12;
              indicator = theme.nord14_sat;
            };
          };
        };
      };
    };
  };
}