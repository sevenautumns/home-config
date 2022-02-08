{ pkgs, config, ... }:
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
        background = nord0;
        foreground = nord6;
        frame_color = nord6;
        highlight = nord9;
        timeout = 10;
      };
      urgency_normal = {
        background = nord0;
        foreground = nord6;
        frame_color = nord6;
        highlight = nord9;
        timeout = 10;
      };
      urgency_critical = {
        background = nord0;
        foreground = nord6;
        frame_color = nord11;
        highlight = nord9;
        timeout = 0;
      };
      # Do not draw when in fullscreen!
      fullscreen_delay_everything.fullscreen = "pushback";
    };
  };
}
