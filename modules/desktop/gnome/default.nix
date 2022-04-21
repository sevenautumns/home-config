{ pkgs, config, inputs, lib, ... }: {
  imports = [ ./rofi.nix ];

  xsession.enable = true;
  xsession.initExtra = ''
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=x11
  '';
  xsession.windowManager.command = "gnome-session";

  home.packages = with pkgs; [
    gnomeExtensions.audio-output-switcher
    gnomeExtensions.pop-shell
    gnomeExtensions.tray-icons-reloaded
  ];
  dconf.settings = let mkTuple = lib.hm.gvariant.mkTuple;
  in {
    "org/gnome/shell".enabled-extensions = [
      "audio-output-switcher@anduchs"
      "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      "pop-shell@system76.com"
      "trayIconsReloaded@selfmade.pl"
      "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    ];
    "org/gnome/desktop/wm/keybindings" = {
      toggle-maximized = [ "<Super>F" ];
      maximize = [ ];
      unmaximize = [ ];
      minimize = [ ];
      close = [ "<Super>C" ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ "<Super><Shift>1" "<Super><Shift>KP_1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" "<Super><Shift>KP_2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" "<Super><Shift>KP_3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" "<Super><Shift>KP_4" ];
      move-to-workspace-down = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      move-to-workspace-last = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-1 = [ "<Super>1" "<Super>KP_1" ];
      switch-to-workspace-2 = [ "<Super>2" "<Super>KP_2" ];
      switch-to-workspace-3 = [ "<Super>3" "<Super>KP_3" ];
      switch-to-workspace-4 = [ "<Super>4" "<Super>KP_4" ];
      switch-to-workspace-down = [ ];
      switch-to-workspace-left = [ "<Super>7" "<Super>KP_7" ];
      switch-to-workspace-right = [ "<Super>9" "<Super>KP_9" ];
      switch-to-workspace-up = [ ];
      switch-to-workspace-last = [ ];
    };
    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
      auto-maximize = false;
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
    "org/gnome/mutter".overlay-key = "Super_R";
    "org/gnome/desktop/wm/preferences".focus-mode = "mouse";
    "org/gnome/desktop/input-sources" = {
      xkb-options = config.home.keyboard.options;
      sources = if config.home.keyboard.variant == ''""'' then
        [ (mkTuple [ "xkb" config.home.keyboard.layout ]) ]
      else
        [
          (mkTuple [
            "xkb"
            "${config.home.keyboard.layout}+${config.home.keyboard.variant}"
          ])
        ];
    };
    "org/gnome/shell/extensions/pop-shell" = {
      activate-launcher = [ ];
      tile-enter = [ "<Super>x" ];
      tile-orientation = [ "<Super>o" ];
      toggle-floating = [ "<Super><Shift>space" ];
      toggle-stacking-global = [ "<Super>z" "<Super>y" ];
      toggle-tiling = [ ];

      show-title = false;
      active-hint = true;
      hint-color-rgba = "rgba(216, 222, 233, 1)";
      snap-to-grid = true;
      smart-gaps = true;

      # Focus Shifting
      focus-left = [ "<Super>Left" ];
      focus-down = [ "<Super>Down" ];
      focus-up = [ "<Super>Up" ];
      focus-right = [ "<Super>Right" ];

      # Tile Management Mode
      management-orientation = [ "o" ];
      tile-accept = [ "Return" ];
      tile-move-down = [ "Down" ];
      tile-move-left = [ "Left" ];
      tile-move-right = [ "Right" ];
      tile-move-up = [ "Up" ];
      tile-reject = [ "Escape" ];
      toggle-stacking = [ "s" ];

      # Resize in normal direction
      tile-resize-left = [ "<Shift>Left" ];
      tile-resize-down = [ "<Shift>Down" ];
      tile-resize-up = [ "<Shift>Up" ];
      tile-resize-right = [ "<Shift>Right" ];

      # Workspace Management -->
      pop-workspace-down = [ ];
      pop-workspace-up = [ ];
      pop-monitor-down = [ "<Super><Shift>Down" ];
      pop-monitor-up = [ "<Super><Shift>Up" ];
      pop-monitor-left = [ "<Super><Shift>Left" ];
      pop-monitor-right = [ "<Super><Shift>Right" ];
    };
  };
}
