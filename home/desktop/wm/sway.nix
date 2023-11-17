{ pkgs, config, machine, lib, ... }:
let
  window-switcher = pkgs.writeShellScriptBin "window-switcher" ''
    swaymsg -t get_tree --raw | \
      ${pkgs.jq}/bin/jq -r '.. | select(.nodes?) | 
        select((.name | length > 0 ) and ((.type == "con") or (.type == "floating_con"))) | 
        "#" + (.id|tostring) + " " + (if (.app_id | length > 0) then .app_id + ": " else "" end) + .name' | \
      ${pkgs.skim}/bin/sk --header="Sway Window Switcher" | \
      awk '/^#[0-9]+/ { system("swaymsg \"[con_id=" substr($1, 2) "] focus\""); exit(0) }' \
  '';
  desktop-mode = pkgs.writeShellScriptBin "desktop-mode" ''
    ${pkgs.sway}/bin/swaymsg output HDMI-A-1 disable
    ${pkgs.sway}/bin/swaymsg output DP-1 enable
    ${pkgs.sway}/bin/swaymsg output DP-3 enable
  '';
  couch-mode = pkgs.writeShellScriptBin "couch-mode" ''
    ${pkgs.sway}/bin/swaymsg output HDMI-A-1 enable
    ${pkgs.sway}/bin/swaymsg output DP-1 disable
    ${pkgs.sway}/bin/swaymsg output DP-3 disable
  '';
in
{
  imports = [ ./rofi.nix ];

  systemd.user.services.wayvnc = {
    Unit = {
      Description = "VNC Server for Sway";
      # Allow it to restart infinitely
      StartLimitIntervalSec = 0;
    };

    Service = {
      ExecStart = "${pkgs.writeShellScript "wayvnc-start" ''
          if [[ $XDG_SESSION_TYPE = "wayland" ]]; then
            ${pkgs.wayvnc}/bin/wayvnc && exit 1
          else
            exit 0
          fi
        ''}";
      Restart = "on-failure";
      RestartSec = "1m";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.file.".config/systemd/user/xdg-desktop-portal-gnome.service".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";

  home.packages = with pkgs;
    [ wl-clipboard sway-launcher-desktop ]
    ++ lib.optionals (machine.host == "neesama") [ desktop-mode couch-mode ];
  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars.default = {
    settings = {
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
    };
    blocks = [
      { block = "disk_space"; }
      {
        block = "memory";
        format = " MEM $mem_used.eng(prefix:M)/$mem_total.eng(prefix:M) ";
      }
      {
        block = "cpu";
        interval = 1;
      }
      { block = "sound"; }
      {
        block = "battery";
        driver = "upower";
      }
      {
        block = "time";
        interval = 60;
      }
    ];
  };

  wayland = with config.theme; {
    windowManager = {
      sway =
        let
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
          wide-tuf = "ASUSTek COMPUTER INC ASUS VG34V R6LMTF119386";
          # tuf = "ASUSTek COMPUTER INC VG279QM L9LMQS257534";
          # fourk = "Samsung Electric Company U28E590 HTPH204116";
          tv = "Samsung Electric Company SAMSUNG 0x00000F00";
          fourthree = "AOC 172S 8416BHA012675";
          laptop = "Chimei Innolux Corporation 0x1529 Unknown";
          wide = "Dell Inc. DELL U3421WE 6B17753";
        in
        {
          enable = true;
          systemd.enable = true;
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
              "type:touchpad" = {
                natural_scroll = "enabled";
                tap = "enabled";
              };
            };
            output = {
              "*".bg = "~/Pictures/Wallpaper/Autumn.png fill";
              ${tv} = {
                mode = "3840x2160@120Hz";
                pos = "0 0";
              };
              ${fourthree} = {
                mode = "1280x1024@75Hz";
                pos = "3840 776";
              };
              ${wide} = {
                mode = "3440x1440@60Hz";
                pos = "4240 0";
              };
              ${wide-tuf} = {
                mode = "3440x1440@164.999Hz";
                pos = "5120 360";
              };
              ${laptop} = {
                mode = "1920x1080@60Hz";
                pos = "7680 540";
              };
            };
            workspaceOutputAssign = [
              {
                output = [ wide-tuf wide ];
                workspace = ws1;
              }
              {
                output = [ wide-tuf wide ];
                workspace = ws2;
              }
              {
                output = [ wide-tuf wide ];
                workspace = ws3;
              }
              {
                output = [ wide-tuf wide ];
                workspace = ws4;
              }
              {
                output = [ wide-tuf wide ];
                workspace = ws5;
              }
              {
                output = [ fourthree laptop ];
                workspace = ws6;
              }
              {
                output = [ fourthree laptop ];
                workspace = ws7;
              }
              {
                output = [ tv fourthree laptop ];
                workspace = ws8;
              }
              {
                output = [ tv fourthree laptop ];
                workspace = ws9;
              }
              {
                output = [ wide-tuf wide ];
                workspace = ws10;
              }
            ];
            keybindings = with config.theme-non_hex;
              pkgs.lib.mkOptionDefault {
                "${modifier}+s" = "layout stacking";
                "${modifier}+y" = "layout tabbed";
                "${modifier}+z" = "layout tabbed";
                "${modifier}+q" = "layout toggle split";
                "${modifier}+Shift+f" = "fullscreen toggle global";
                "${modifier}+h" = "split h";
                "${modifier}+v" = "split v";
                "${modifier}+c" = "kill";
                "${modifier}+x" = "move workspace to output next";
                "${modifier}+u" = "mode passthrough";

                "${modifier}+m" = "exec ${pkgs.warpd}/bin/warpd --grid";
                "${modifier}+l" = "exec swaylock";

                # "${modifier}+d" = "exec rofi -no-lazy-grab -show drun -modi drun";
                "${modifier}+d" =
                  "exec alacritty --class=launcher -e sway-launcher-desktop";
                "${modifier}+t" =
                  "exec alacritty --class=launcher -e ${window-switcher}/bin/window-switcher";
                # "${modifier}+t" = "exec rofi -show window -modi window";
                # "${modifier}+t" = "exec ${pkgs.swayr}/bin/swayr switch-workspace-or-window";
                # "${modifier}+p" = "exec rofi-pass";
                "${modifier}+p" = "exec ${pkgs.tessen}/bin/tessen";

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
            modes = {
              passthrough = {
                "${modifier}+u" = "mode default";
              };
              resize = {
                Left = "resize shrink width 10px";
                Down = "resize grow height 10px";
                Up = "resize shrink height 10px";
                Right = "resize grow width 10px";
                Escape = "mode default";
                Return = "mode default";
              };
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
            window.commands = [{
              criteria = { app_id = "^launcher$"; };
              command =
                "floating enable, sticky enable, resize set 30 ppt 60 ppt, border pixel 5";
            }];
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
      show-keyboard-layout = false;
      image = "~/Pictures/Wallpaper/Autumn.png";
      color = gray0;
      ring-color = brown;
      ring-ver-color = brown;
      ring-wrong-color = red;
      inside-color = "${gray0}C0";
      inside-clear-color = "${gray0}C0";
      inside-ver-color = "${gray0}C0";
      inside-wrong-color = "${gray0}C0";
      line-uses-inside = true;
      key-hl-color = red;
      bs-hl-color = red;
      separator-color = gray0;
      text-color = brown;
      text-ver-color = brown;
      text-wrong-color = brown;
      text-clear-color = brown;
    };
  };
}
