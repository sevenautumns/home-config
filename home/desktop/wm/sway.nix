{ pkgs, config, machine, lib, ... }: {
  imports = [ ./rofi.nix ];

  services.clipman.enable = true;
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

  wayland = with config.theme; {
    # enable = true;
    # initExtra = ''
    #   # ${pkgs.xorg.xsetroot}/bin/xsetroot -solid '${config.theme.black}'
    # '';
    windowManager = {
      sway = let
        fonts = {
          names = [ "Ttyp0" "Sarasa UI J" ];
          # names = [ "Ttyp0" "Fixed" ];
          size = 9.0;
        };
        modifier = config.wayland.windowManager.sway.config.modifier;
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
        tuf = "ASUSTek COMPUTER INC VG279QM L9LMQS257534";
        fourk = "Samsung Electric Company U28E590 HTPH204116";
        tv = "Samsung Electric Company SAMSUNG 0x00000F00";
      in {
        enable = true;
        systemdIntegration = true;
        config = {
          terminal = "alacritty";
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
          input = {
            "*" = {
              xkb_variant = "us";
              xkb_layout = "de";
              xkb_model = "pc105";
              xkb_options = "caps:escape";
              xkb_numlock = "enabled";
            };
          };
          output = {
            "${tv}" = {
              bg = "~/Pictures/Wallpaper/Autumn.png fill";
              mode = "3840x2160@120Hz";
              scale = "1";
              pos = "0 0";
            };
            "${fourk}" = {
              bg = "~/Pictures/Wallpaper/Autumn.png fill";
              mode = "3840x2160@60Hz";
              scale = "2";
              pos = "3840 540";
            };
            "${tuf}" = {
              bg = "~/Pictures/Wallpaper/Autumn.png fill";
              mode = "1920x1080@240Hz";
              scale = "1";
              pos = "5760 540";
            };
          };
          workspaceOutputAssign = [
            {
              output = tuf;
              workspace = ws10;
            }
            {
              output = tuf;
              workspace = ws1;
            }
            {
              output = tuf;
              workspace = ws2;
            }
            {
              output = tuf;
              workspace = ws3;
            }
            {
              output = tuf;
              workspace = ws4;
            }
            {
              output = tuf;
              workspace = ws5;
            }
            {
              output = fourk;
              workspace = ws6;
            }
            {
              output = fourk;
              workspace = ws7;
            }
            {
              output = tv;
              workspace = ws8;
            }
            {
              output = tv;
              workspace = ws9;
            }
          ];
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

              "${modifier}+l" = "exec swaylock";
              # "${modifier}+l" = ''
              #   exec ${pkgs.i3lock-color}/bin/i3lock-color \
              #     --nofork \
              #     --color '${gray0}' \
              #     --clock \
              #     --indicator \
              #     --inside-color="${gray0}" \
              #     --ring-color="${brown}" \
              #     --insidever-color="${gray0}" \
              #     --ringver-color="${yellow1}" \
              #     --insidewrong-color="${gray0}" \
              #     --ringwrong-color="${red}" \
              #     --line-uses-inside \
              #     --keyhl-color="${red}" \
              #     --bshl-color="${red}" \
              #     --separator-color="${gray0}" \
              #     --verif-color="${gray0}" \
              #     --wrong-color="${gray0}" \
              #     --modif-color="${gray0}" \
              #     --verif-color="${white}" \
              #     --wrong-color="${white}" \
              #     --modif-color="${white}" \
              #     --layout-color="${white}" \
              #     --date-color="${white}" \
              #     --time-color="${white}" \
              #     --pass-media-keys \
              #     --pass-volume-keys \
              #     --blur=1 \
              #     --no-modkey-text \
              #     --layout-font="Roboto"
              # '';

              "${modifier}+d" = "exec rofi -no-lazy-grab -show drun -modi drun";
              # "${modifier}+t" = "exec rofi -show window -modi window";
              "${modifier}+p" = "exec rofi-pass";

              "${modifier}+o" = "exec alacritty --class=launcher -e pulsemixer";

              "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
              "${modifier}+Shift+Return" = ''
                exec ${pkgs.alacritty}/bin/alacritty --working-directory="$(${pkgs.xcwd}/bin/xcwd)"'';
              "${modifier}+e" = "exec ${pkgs.xdg-utils}/bin/xdg-open ~";
              "${modifier}+Shift+e" = ''
                exec ${pkgs.xdg-utils}/bin/xdg-open "$(${pkgs.xcwd}/bin/xcwd)"'';

              "${modifier}+w" = "exec firefox";

              # "${modifier}+Escape" = ''
              #   exec i3-nagbar  \
              #     -t warning  \
              #     -m 'power menu' \
              #     -b 'reboot' 'reboot' \
              #     -b 'shutdown' 'poweroff' \
              #     -b 'logout' 'i3-msg exit' 
              # '';

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
          startup = [ ] ++ lib.optionals (machine.user == "autumnal") [{
            command =
              "pass show linux/local/autumnal | gnome-keyring-daemon --unlock --replace";
          }];
        };
        extraConfig = ''
          for_window [instance="^launcher$"] floating enable sticky enable resize set 30 ppt 60 ppt border normal 10
        '';
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings = with config.theme-non_hex; {
      indicator-idle-visible = true;
      indicator-radius = 100;
      show-keyboard-layout = true;
      image = "~/Pictures/Wallpaper/Autumn.png";
      color = gray0;
      inside-color = gray0;
      ring-color = brown;
      inside-ver-color = gray0;
      ring-ver-color = gray0;
      inside-wrong-color = gray0;
      ring-wrong-color = red;
      line-uses-inside = true;
      key-hl-color = red;
      bs-hl-color = red;
      text-color = brown;
      separator-color = gray0;
      text-ver-color = gray0;
      text-wrong-color = gray0;
    };
  };
}
