{ pkgs, config, machine, lib, inputs, ... }: {
  imports = [ ./polybar.nix ];

  home.packages = [ inputs.herbst3.packages."${pkgs.system}".herbst3 pkgs.feh ];

  xsession = with config.theme; {
    enable = true;
    initExtra = ''
      ${pkgs.hsetroot}/bin/hsetroot -solid '${config.theme.black}'
      ~/.screenlayout/normal.sh || true
      feh --bg-scale ~/Pictures/Wallpaper/Autumn.png &
    '' + lib.strings.optionalString (machine.user == "autumnal") ''
      pass show linux/local/autumnal | gnome-keyring-daemon --unlock --replace &
    '';
    windowManager.herbstluftwm = {
      enable = true;
      # package = pkgs.herbstluftwm.overrideAttrs (orig: {
      #   # version = "git";
      #   # src = inputs.herbstluftwm;
      #   doCheck = false;
      #   # buildInputs = orig.buildInputs ++ [ pkgs.python3 ];
      #   # postPatch = orig.postPatch + ''
      #   #   patchShebangs doc/format-doc.py
      #   # '';
      # });
      tags = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
      keybinds = {
        Mod4-c = "close_and_remove";
        Mod4-Alt-c = "close";
        Mod4-q = "quit";
        Mod4-Shift-r = "reload";
        Mod4-v = "split right 0.5";
        Mod4-h = "split bottom 0.5";
        Mod4-f = "fullscreen";
        Mod4-x = "cycle_monitor";
        Mod4-Shift-space = "set_attr clients.focus.floating toggle";

        Mod4-Left = "focus left --level=all";
        Mod4-Down = "focus down --level=all";
        Mod4-Up = " focus up --level=all";
        Mod4-Right = "focus right --level=all";
        Mod4-Ctrl-Left = "focus left --level=visible";
        Mod4-Ctrl-Down = "focus down --level=visible";
        Mod4-Ctrl-Up = " focus up --level=visible";
        Mod4-Ctrl-Right = "focus right --level=visible";
        Mod4-Shift-Left = "spawn herbst3 shift left";
        Mod4-Shift-Down = "spawn herbst3 shift down";
        Mod4-Shift-Up = "spawn herbst3 shift up";
        Mod4-Shift-Right = "spawn herbst3 shift right";
        Mod4-Shift-Ctrl-Left = "spawn herbst3 shift left --frame";
        Mod4-Shift-Ctrl-Down = "spawn herbst3 shift down --frame";
        Mod4-Shift-Ctrl-Up = "spawn herbst3 shift up --frame";
        Mod4-Shift-Ctrl-Right = "spawn herbst3 shift right --frame";
        Mod4-Alt-Left = "shift left --level=all";
        Mod4-Alt-Down = "shift down --level=all";
        Mod4-Alt-Up = " shift up --level=all";
        Mod4-Alt-Right = "shift right --level=all";

        Mod4-KP_End = "use 1";
        Mod4-KP_Down = "use 2";
        Mod4-KP_Next = "use 3";
        Mod4-KP_Left = "use 4";
        Mod4-KP_Begin = "use 5";
        Mod4-KP_Right = "use 6";
        Mod4-KP_Home = "use 7";
        Mod4-KP_Up = "use 8";
        Mod4-KP_Prior = "use 9";
        Mod4-KP_Insert = "use 0";
        Mod4-1 = "use 1";
        Mod4-2 = "use 2";
        Mod4-3 = "use 3";
        Mod4-4 = "use 4";
        Mod4-5 = "use 5";
        Mod4-6 = "use 6";
        Mod4-7 = "use 7";
        Mod4-8 = "use 8";
        Mod4-9 = "use 9";
        Mod4-0 = "use 0";

        Mod4-Shift-KP_End = "move_index 1";
        Mod4-Shift-KP_Down = "move_index 2";
        Mod4-Shift-KP_Next = "move_index 3";
        Mod4-Shift-KP_Left = "move_index 4";
        Mod4-Shift-KP_Begin = "move_index 5";
        Mod4-Shift-KP_Right = "move_index 6";
        Mod4-Shift-KP_Home = "move_index 7";
        Mod4-Shift-KP_Up = "move_index 8";
        Mod4-Shift-KP_Prior = "move_index 9";
        Mod4-Shift-KP_Insert = "move_index 0";
        Mod4-Shift-1 = "move_index 1";
        Mod4-Shift-2 = "move_index 2";
        Mod4-Shift-3 = "move_index 3";
        Mod4-Shift-4 = "move_index 4";
        Mod4-Shift-5 = "move_index 5";
        Mod4-Shift-6 = "move_index 6";
        Mod4-Shift-7 = "move_index 7";
        Mod4-Shift-8 = "move_index 8";
        Mod4-Shift-9 = "move_index 9";
        Mod4-Shift-0 = "move_index 0";

        Mod4-l = ''
          spawn ${pkgs.i3lock-color}/bin/i3lock-color \
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

        Mod4-d = "spawn rofi -no-lazy-grab -show drun -modi drun";
        Mod4-t = "spawn rofi -show window -modi window";
        Mod4-p = "spawn rofi-pass";

        Mod4-o = "spawn alacritty --class=launcher -e pulsemixer";

        Mod4-Return = "spawn ${pkgs.alacritty}/bin/alacritty";
        Mod4-Shift-Return = ''
          spawn ${pkgs.alacritty}/bin/alacritty --working-directory="$(${pkgs.xcwd}/bin/xcwd)"'';
        Mod4-e = "spawn ${pkgs.xdg-utils}/bin/xdg-open ~";
        Mod4-Shift-e =
          ''spawn ${pkgs.xdg-utils}/bin/xdg-open "$(${pkgs.xcwd}/bin/xcwd)"'';
        Mod4-w = "spawn firefox";

        XF86AudioMute = "spawn ${pkgs.pamixer}/bin/pamixer -t";
        XF86AudioLowerVolume = "spawn ${pkgs.pamixer}/bin/pamixer -d 5";
        XF86AudioRaiseVolume = "spawn ${pkgs.pamixer}/bin/pamixer -i 5";
        XF86AudioPlay = "spawn ${pkgs.playerctl}/bin/playerctl play-pause";
        XF86AudioNext = "spawn ${pkgs.playerctl}/bin/playerctl next";
        XF86AudioPrev = "spawn ${pkgs.playerctl}/bin/playerctl previous";
        XF86MonBrightnessUp = "spawn ${pkgs.light}/bin/light -A 10";
        XF86MonBrightnessDown = "spawn ${pkgs.light}/bin/light -U 10";
      };
      mousebinds = {
        Mod4-Button1 = "move";
        Mod4-Button2 = "zoom";
        Mod4-Button3 = "resize";
      };
      settings = with config.theme; {
        default_frame_layout = "max";
        tabbed_max = true;
        frame_border_active_color = brown;
        frame_border_normal_color = gray3;
        frame_bg_normal_color = gray0;
        frame_bg_active_color = brown;
        frame_border_width = 1;
        show_frame_decorations = "focused_if_multiple";
        frame_bg_transparent = "all";
        frame_transparent_width = 5;
        frame_gap = 4;
        hide_covered_windows = true;
        swap_monitors_to_get_tag = false;
        auto_detect_monitors = true;
        frame_active_opacity = 95;
        update_dragged_clients = true;
      };
      rules = [
        "focus=on"
        "windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on"
        "windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on"
        "windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off"
      ];
      extraConfig = with config.theme; ''
        herbstclient attr theme.title_height 12
        herbstclient attr theme.title_when always
        herbstclient attr theme.title_font 'Ttyp0:pixelsize=9'
        herbstclient attr theme.title_depth 3  # space below the title's baseline
        herbstclient attr theme.active.color '${brown}'
        herbstclient attr theme.title_color '${gray0}'
        herbstclient attr theme.normal.color '${gray3}'
        herbstclient attr theme.urgent.color '${red}'
        herbstclient attr theme.tab_color '${gray0}'
        herbstclient attr theme.active.tab_color '${gray0}'
        herbstclient attr theme.active.tab_outer_color '${gray0}'
        herbstclient attr theme.active.tab_title_color '${gray5}'
        herbstclient attr theme.normal.title_color '${gray5}'
        herbstclient attr theme.inner_width 1
        herbstclient attr theme.inner_color '${gray0}'
        herbstclient attr theme.border_width 4
        herbstclient attr theme.floating.border_width 1
        herbstclient attr theme.floating.outer_width 1
        herbstclient attr theme.floating.outer_color '${gray0}'
        herbstclient attr theme.active.inner_color '${gray0}'
        herbstclient attr theme.urgent.inner_color '${gray0}'
        herbstclient attr theme.normal.inner_color '${gray0}'
        # copy inner color to outer_color
        for state in active urgent normal ; do
            herbstclient substitute C theme.''${state}.inner_color \
                attr theme.''${state}.outer_color C
        done
        herbstclient attr theme.tiling.outer_width 2
        herbstclient attr theme.background_color '${gray0}'

        herbstclient chain - use 1 - merge_tag default 1 || true
      '';
    };
  };
}
