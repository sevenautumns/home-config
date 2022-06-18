{ pkgs, config, inputs, lib, machine, ... }:
let host = machine.host;
in {
  imports = [ ./rofi.nix ./popshell.nix ];

  xsession.enable = true;
  xsession.initExtra = ''
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=x11
  '';
  xsession.windowManager.command = "gnome-session";

  home.packages = with pkgs;
    [
      gnomeExtensions.audio-output-switcher
      gnomeExtensions.tray-icons-reloaded
    ] ++ lib.optionals (host != "neesama") [ gnome.gnome-session ];
  dconf.settings = let mkTuple = lib.hm.gvariant.mkTuple;
  in {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "audio-output-switcher@anduchs"
        "pop-shell@system76.com"
        #"material-shell@papyelgringo"
        "trayIconsReloaded@selfmade.pl"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      disabled-extensions = [
        #"pop-shell@system76.com"
        "material-shell@papyelgringo"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/desktop/applications/terminal" = {
      exec = "${config.programs.alacritty.package}/bin/alacritty";
    };
    "org/gnome/desktop/wm/keybindings" = {
      toggle-maximized = [ ];
      toggle-fullscreen = [ "<Super>F" ];
      maximize = [ ];
      unmaximize = [ ];
      minimize = [ ];
      close = [ "<Super>C" ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ "<Shift><Super>KP_End" ];
      move-to-workspace-2 = [ "<Shift><Super>KP_Down" ];
      move-to-workspace-3 = [ "<Shift><Super>KP_Next" ];
      move-to-workspace-4 = [ "<Shift><Super>KP_Left" ];
      move-to-workspace-5 = [ "<Shift><Super>KP_Begin" ];
      move-to-workspace-6 = [ "<Shift><Super>KP_Right" ];
      move-to-workspace-7 = [ "<Shift><Super>KP_Home" ];
      move-to-workspace-8 = [ "<Shift><Super>KP_Up" ];
      move-to-workspace-9 = [ "<Shift><Super>KP_Prior" ];
      move-to-workspace-10 = [ "<Shift><Super>KP_Insert" ];
      move-to-workspace-down = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      move-to-workspace-last = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-1 = [ "<Super>KP_End" ];
      switch-to-workspace-2 = [ "<Super>KP_Down" ];
      switch-to-workspace-3 = [ "<Super>KP_Next" ];
      switch-to-workspace-4 = [ "<Super>KP_Left" ];
      switch-to-workspace-5 = [ "<Super>KP_Begin" ];
      switch-to-workspace-6 = [ "<Super>KP_Right" ];
      switch-to-workspace-7 = [ "<Super>KP_Home" ];
      switch-to-workspace-8 = [ "<Super>KP_Up" ];
      switch-to-workspace-9 = [ "<Super>KP_Prior" ];
      switch-to-workspace-10 = [ "<Super>KP_Insert" ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-left = [ "<Primary><Super>Left" ];
      switch-to-workspace-right = [ "<Primary><Super>Right" ];
      switch-to-workspace-up = [ ];
      switch-to-workspace-last = [ ];
    };
    "org.gnome.desktop.sound".theme-name = "Yaru";
    "org/gnome/desktop/screensaver" = {
      lock-delay = lib.hm.gvariant.mkUint32 30;
      lock-enabled = true;
    };
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
      attach-modal-dialogs = false;
      edge-tiling = false;
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      color-scheme = "prefer-dark";
      font-name = "Roboto 11";
      document-font-name = "Roboto 11";
      monospace-font-name = "Dina 10";
      cursor-theme = "Bibata-Original-Classic";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-temperature = lib.hm.gvariant.mkUint32 3600;
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
    "org/gnome/mutter".overlay-key = "Super_R";
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "click";
      titlebar-font = "Roboto Bold 11";
    };
    "org/gnome/desktop/input-sources" = let
      layout = config.home.keyboard.layout;
      variant = config.home.keyboard.variant;
    in {
      xkb-options = config.home.keyboard.options;
      sources = if variant == ''""'' then
        [ (mkTuple [ "xkb" layout ]) ]
      else
        [ (mkTuple [ "xkb" "${layout}+${variant}" ]) ];
    };
  };
}
