{ pkgs, config, inputs, lib, ... }: {
  home.packages = with pkgs; [ gnomeExtensions.material-shell ];

  dconf.settings = {
    "org/gnome/shell/extensions/materialshell/bindings" = {
      app-launcher = [ "<Super>d" ];
      cycle-tiling-layout = [ "" ];
      focus-monitor-down = [ "" ];
      focus-monitor-left = [ "<Super>KP_7" ];
      focus-monitor-right = [ "<Super>KP_9" ];
      focus-monitor-up = [ "" ];
      kill-focused-window = [ "<Super>c" ];
      last-workspace = [ "" ];
      move-window-bottom = [ "" ];
      move-window-left = [ "<Shift><Super>Left" ];
      move-window-monitor-down = [ "<Shift><Super>Down" ];
      move-window-monitor-left = [ "<Shift><Super>KP_Home" ];
      move-window-monitor-right = [ "<Shift><Super>KP_Page_Up" ];
      move-window-monitor-up = [ "<Shift><Super>Up" ];
      move-window-right = [ "<Shift><Super>Right" ];
      move-window-top = [ "" ];
      move-window-to-workspace-1 = [ "<Shift><Super>KP_End" ];
      move-window-to-workspace-2 = [ "<Shift><Super>KP_Down" ];
      move-window-to-workspace-3 = [ "<Shift><Super>KP_Next" ];
      move-window-to-workspace-4 = [ "<Shift><Super>KP_Left" ];
      move-window-to-workspace-5 = [ "<Shift><Super>KP_Begin" ];
      move-window-to-workspace-6 = [ "<Shift><Super>KP_Right" ];
      move-window-to-workspace-7 = [ "<Shift><Super>KP_Home" ];
      move-window-to-workspace-8 = [ "<Shift><Super>KP_Up" ];
      move-window-to-workspace-9 = [ "<Shift><Super>KP_Page_Up" ];
      move-window-to-workspace-10 = [ "<Shift><Super>KP_Insert" ];
      navigate-to-workspace-1 = [ "<Super>KP_1" ];
      navigate-to-workspace-2 = [ "<Super>KP_2" ];
      navigate-to-workspace-3 = [ "<Super>KP_3" ];
      navigate-to-workspace-4 = [ "<Super>KP_4" ];
      navigate-to-workspace-5 = [ "<Super>KP_5" ];
      navigate-to-workspace-6 = [ "<Super>KP_6" ];
      navigate-to-workspace-7 = [ "" ];
      navigate-to-workspace-8 = [ "" ];
      navigate-to-workspace-9 = [ "" ];
      navigate-to-workspace-10 = [ "<Super>KP_0" ];
      next-window = [ "<Super>Right" ];
      next-workspace = [ "<Super>Down" ];
      previous-window = [ "<Super>Left" ];
      previous-workspace = [ "<Super>Up" ];
      reverse-cycle-tiling-layout = [ "" ];
      use-grid-layout = [ "<Super>g" ];
      use-half-layout = [ "<Super>z" ];
      use-maximize-layout = [ "<Super>x" ];
      use-split-layout = [ "<Super>e" ];
      use-float-layout = [ "<Super>v" ];
    };
    # Adjust tray reloaded for material shell
    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-margin-horizontal = 0;
      icon-padding-horizontal = 0;
      icon-padding-vertical = 5;
      icon-size = 20;
      icons-limit = 15;
      invoke-to-workspace = true;
      position-weight = 0;
      tray-margin-left = 0;
      tray-margin-right = 0;
      tray-position = "right";
      wine-behavior = true;
    };
  };
}
