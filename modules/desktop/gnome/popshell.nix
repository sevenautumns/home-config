{ pkgs, config, inputs, lib, ... }: {
  home.packages = with pkgs; [ gnomeExtensions.pop-shell ];

  xdg.configFile."pop-shell/config.json".text = builtins.toJSON {
    skiptaskbarhidden = [ ];
    log_on_focus = false;
    move_pointer_on_switch = true;
    default_pointer_position = "CENTER";
    float = [
      { class = "Authy Desktop"; }
      {
        class = "Enpass";
        title = "Enpass Assistant";
      }
      {
        class = "Zotero";
        title = "Quick Format Citation";
      }
      { class = "Com.github.donadigo.eddy"; }
      { class = "Conky"; }
      { class = "gnome-screenshot"; }
      { class = "jetbrains-toolbox"; }
      {
        class = "jetbrains-webstorm";
        title = "License Activation";
      }
      {
        class = "jetbrains-webstorm";
        title = "Customize WebStorm";
      }
      {
        class = "jetbrains-webstorm";
        title = "Welcome to WebStorm";
      }
      {
        class = "KotatogramDesktop";
        title = "Media viewer";
      }
      {
        class = "Steam";
        title = "^((?!Steam).)*$";
      }
      {
        class = "TelegramDesktop";
        title = "Media viewer";
      }
      {
        class = "Slack";
        title = "Slack | mini panel";
      }
      { class = "Solaar"; }
      { class = "system76-driver"; }
      { class = "zoom"; }
      {
        class = "Gnome-terminal";
        title = "Preferences – General";
      }
      {
        class = "Gjs";
        title = "Settings";
      }
      {
        class = "syncplay";
        title = "Syncplay configuration";
      }
      { class = "Io.elementary.sideload"; }
    ];
  };

  dconf.settings = {
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
      snap-to-grid = false;
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
