{ pkgs, config, inputs, lib, ... }: {
  imports = [ ./rofi.nix ./materialshell.nix ];

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
        #"pop-shell@system76.com"
        "trayIconsReloaded@selfmade.pl"
        "material-shell@papyelgringo"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      ];
      disabled-extensions = [
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "pop-shell@system76.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      toggle-maximized = [ ];
      toggle-fullscreen = [ "<Super>F" ];
      maximize = [ ];
      unmaximize = [ ];
      minimize = [ ];
      close = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ ];
      move-to-workspace-2 = [ ];
      move-to-workspace-3 = [ ];
      move-to-workspace-4 = [ ];
      move-to-workspace-5 = [ ];
      move-to-workspace-6 = [ ];
      move-to-workspace-7 = [ ];
      move-to-workspace-8 = [ ];
      move-to-workspace-down = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      move-to-workspace-last = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-1 = [ ];
      switch-to-workspace-2 = [ ];
      switch-to-workspace-3 = [ ];
      switch-to-workspace-4 = [ ];
      switch-to-workspace-5 = [ ];
      switch-to-workspace-6 = [ ];
      switch-to-workspace-7 = [ ];
      switch-to-workspace-8 = [ ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      switch-to-workspace-up = [ ];
      switch-to-workspace-last = [ ];
    };
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
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-temperature = lib.hm.gvariant.mkUint32 3600;
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
    "org/gnome/mutter".overlay-key = "Super_R";
    "org/gnome/desktop/wm/preferences".focus-mode = "click";
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
