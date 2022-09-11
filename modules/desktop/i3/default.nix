{ pkgs, config, lib, ... }: {

  services.redshift = {
    enable = true;
    latitude = 51.8;
    longitude = 10.3;
  };

  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars.default.settings = {
    theme = {
      # name = "plain";
      overrides = with config.theme; {
        idle_bg = gray0;
        idle_fg = gray5;
        info_bg = gray0;
        info_fg = gray5;
        good_bg = gray0;
        good_fg = green;
        warning_bg = gray0;
        warning_fg = yellow1;
        critical_bg = gray0;
        critical_fg = red;
        separator_bg = gray0;
        separator_fg = gray5;
      };
    };
    blocks = [
      {
        block = "disk_space";
        path = "/";
        alias = "/";
        info_type = "available";
        unit = "GB";
        interval = 60;
        warning = 20.0;
        alert = 10.0;
      }
      {
        block = "memory";
        display_type = "memory";
        format_mem = "{mem_used_percents}";
        format_swap = "{swap_used_percents}";
      }
      {
        block = "cpu";
        interval = 1;
      }
      {
        block = "load";
        interval = 1;
        format = "{1m}";
      }
      { block = "sound"; }
      {
        block = "time";
        interval = 60;
        format = "%a %d/%m %r";
      }
    ];
  };

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
        # package = with pkgs; i3-gaps;
        config = {
          terminal = "alacritty";
          # startup = [{
          #   # Polybar sometimes starts faster than i3, 
          #   # resulting in the i3-module not activating
          #   command = "systemctl --user restart polybar.service";
          #   always = true;
          #   notification = false;
          # }];
          bars = [{
            colors = with config.theme; {
              activeWorkspace = {
                background = gray2;
                border = gray3;
                text = gray5;
              };
              background = gray0;
              bindingMode = {
                background = red;
                border = red;
                text = gray0;
              };
              focusedWorkspace = {
                background = brown;
                border = yellow1;
                text = gray0;
              };
              inactiveWorkspace = {
                background = gray0;
                border = gray3;
                text = gray5;
              };
              separator = gray5;
              statusline = gray5;
              urgentWorkspace = {
                background = red;
                border = red;
                text = gray0;
              };
            };

            statusCommand =
              "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }];
          window.border = 1;
          # gaps = {
          #   inner = 12;
          #   outer = 0;
          #   smartBorders = "no_gaps";
          # };
          fonts = {
            # names = [ "Roboto" ];
            names = [ "Dina" "Sarasa UI J" ];
            size = 10.0;
          };
          modifier = "Mod4";
          keybindings = pkgs.lib.mkOptionDefault {
            "${modifier}+s" = "layout stacking";
            "${modifier}+y" = "layout tabbed";
            "${modifier}+z" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+h" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+c" = "kill";
            "${modifier}+x" = "move workspace to output next";

            "${modifier}+w" = "exec firefox";
            "${modifier}+Shift+Return" =
              "exec ${pkgs.gnome.nautilus}/bin/nautilus --new-window";

            "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
            "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
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
          colors = with config.theme; {
            background = gray0;
            focused = {
              background = brown;
              text = gray0;
              border = brown;
              childBorder = brown;
              indicator = red;
            };
            unfocused = {
              background = gray0;
              text = gray5;
              border = gray3;
              childBorder = gray3;
              indicator = gray1;
            };
            focusedInactive = {
              background = gray2;
              text = gray5;
              border = gray3;
              childBorder = gray3;
              indicator = gray3;
            };
            urgent = {
              background = red;
              text = gray0;
              border = red;
              childBorder = red;
              indicator = white2;
            };
          };
        };
      };
    };
  };
}
