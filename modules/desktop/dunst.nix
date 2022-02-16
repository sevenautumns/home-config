{ pkgs, config, ... }:
let
  theme = config.theme;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        geometry = "300x5-30+20";
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#eceff4";
        separator_color = "frame";
        idle_threshold = 120;
        font = "Monospace 9";
        format = ''
          <b>%s</b>
          %b'';
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 54;
        history_length = 20;
        dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
        browser = "${pkgs.brave}/bin/brave -new-tab";
        corner_radius = 0;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };
      experimental.per_monitor_dpi = false;
      urgency_low = {
        background = theme.nord0;
        foreground = theme.nord6;
        frame_color = theme.nord6;
        highlight = theme.nord9;
        timeout = 10;
      };
      urgency_normal = {
        background = theme.nord0;
        foreground = theme.nord6;
        frame_color = theme.nord6;
        highlight = theme.nord9;
        timeout = 10;
      };
      urgency_critical = {
        background = theme.nord0;
        foreground = theme.nord6;
        frame_color = theme.nord11;
        highlight = theme.nord9;
        timeout = 0;
      };
      # Do not draw when in fullscreen!
      fullscreen_delay_everything.fullscreen = "pushback";
    };
  };
}
