{ pkgs, config, lib, ... }: {
  imports = [ ./rofi.nix ];

  services.redshift = {
    enable = true;
    # Germany
    latitude = 51.8;
    longitude = 10.3;
    # Japan
    # latitude = 35.6;
    # longitude = 139.8;
    settings.redshift.transition = 0;
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

  xsession = with config.theme; {
    enable = true;
    initExtra = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '${config.theme.black}'
    '';
    windowManager = {
      i3 = let
        fonts = {
          # names = [ "Ttyp0" "Sarasa UI J" ];
          names = [ "Ttyp0" "Fixed" ];
          size = 9.0;
        };
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
      in {
        enable = true;
        # package = pkgs.i3-gaps;
        config = {
          terminal = "alacritty";
          # menu = ''
          #   ${pkgs.dmenu}/bin/dmenu_run \
          #     -nb '${black}' \
          #     -nf '${gray5}' \
          #     -sb '${brown}' \
          #     -sf '${gray0}' \
          #     -fn ${font}
          # '';
          # startup = [{
          #   # Polybar sometimes starts faster than i3, 
          #   # resulting in the i3-module not activating
          #   command = "systemctl --user restart polybar.service";
          #   always = true;
          #   notification = false;
          # }];
          bars = [{
            colors = {
              activeWorkspace = {
                background = gray3;
                border = gray3;
                text = white;
              };
              background = gray0;
              bindingMode = {
                background = red;
                border = red;
                text = gray0;
              };
              focusedWorkspace = {
                background = brown;
                border = brown;
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
            fonts = fonts;
            # mode = "hide";
            statusCommand =
              "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          }];
          window.border = 2;
          gaps = {
            inner = 5;
            outer = 0;
            smartBorders = "off";
            smartGaps = false;
          };
          fonts = fonts;
          modifier = "Mod4";
          focus.followMouse = false;
          keybindings = with config.theme-non_hex;
            pkgs.lib.mkOptionDefault {
              "${modifier}+s" = "layout stacking";
              "${modifier}+y" = "layout tabbed";
              "${modifier}+z" = "layout tabbed";
              "${modifier}+q" = "layout toggle split";
              "${modifier}+h" = "split h";
              "${modifier}+v" = "split v";
              "${modifier}+c" = "kill";
              "${modifier}+x" = "move workspace to output next";

              "${modifier}+l" = ''
                exec ${pkgs.i3lock-color}/bin/i3lock-color \
                  --nofork \
                  --color '${gray0}' \
                  --clock \
                  --indicator \
                  --inside-color="${gray0}" \
                  --ring-color="${brown}" \
                  --insidever-color="${gray0}" \
                  --ringver-color="${yellow1}" \
                  --insidewrong-color="${gray0}" \
                  --ringwrong-color="${red}" \
                  --line-uses-inside \
                  --keyhl-color="${red}" \
                  --bshl-color="${red}" \
                  --separator-color="${gray0}" \
                  --verif-color="${gray0}" \
                  --wrong-color="${gray0}" \
                  --modif-color="${gray0}" \
                  --verif-color="${white}" \
                  --wrong-color="${white}" \
                  --modif-color="${white}" \
                  --layout-color="${white}" \
                  --date-color="${white}" \
                  --time-color="${white}" \
                  --pass-media-keys \
                  --pass-volume-keys \
                  --blur=1 \
                  --no-modkey-text \
                  --layout-font="Roboto"
              '';

              "${modifier}+d" = "exec rofi -no-lazy-grab -show drun -modi drun";
              "${modifier}+t" = "exec rofi -show window -modi window";
              "${modifier}+p" = "exec rofi-pass";

              "${modifier}+o" = "exec alacritty --class=launcher -e pulsemixer";

              "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
              "${modifier}+Shift+Return" = ''
                exec ${pkgs.alacritty}/bin/alacritty --working-directory="$(${pkgs.xcwd}/bin/xcwd)"'';
              "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";
              "${modifier}+Shift+e" = ''
                exec ${pkgs.xdg-utils}/bin/xdg-open "$(${pkgs.xcwd}/bin/xcwd)"'';

              "${modifier}+w" = "exec firefox";
              # "${modifier}+Shift+Return" =
              #   "exec ${pkgs.gnome.nautilus}/bin/nautilus --new-window";

              "${modifier}+Escape" = ''
                exec i3-nagbar  \
                  -t warning  \
                  -m 'power menu' \
                  -b 'reboot' 'reboot' \
                  -b 'shutdown' 'poweroff' \
                  -b 'logout' 'i3-msg exit' 
              '';

              "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
              "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
              "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
              "XF86AudioPlay" =
                "exec ${pkgs.playerctl}/bin/playerctl play-pause";
              "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
              "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
              "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
              "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
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
          # modes = {

          # };
          colors = {
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
              background = gray3;
              text = white;
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
        extraConfig = ''
          for_window [instance="^launcher$"] floating enable sticky enable resize set 30 ppt 60 ppt border normal 10
        '';
      };
    };
  };
}
