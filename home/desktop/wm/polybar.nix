{ pkgs, config, lib, ... }: {
  services.polybar = {
    enable = true;
    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload &
      done
    '';
    package = pkgs.polybarFull;
    config = with config.theme; {
      "bar/main" = {
        monitor = "\${env:MONITOR}";
        width = "100%";
        height = "12pt";
        bottom = true;
        tray-position = "right";
        tray-detached = false;
        background = background;
        foreground = white;
        line-size = "1pt";
        padding-right = 1;
        module-margin = 1;
        separator = "|";
        separator-foreground = foreground-dark;
        font-0 = "ttyp0;2";
        modules-left = "xworkspaces xwindow";
        modules-right = "filesystem memory cpu wlan eth pulseaudio date";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        reverse-scroll = true;
        enable-ipc = true;
      };
      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label-active = "%name%";
        label-active-background = background-light1;
        label-active-underline = primary;
        label-active-padding = "1";
        label-occupied = "%name%";
        label-occupied-padding = "1";
        label-urgent = "%name%";
        label-urgent-background = red;
        label-urgent-padding = "1";
        label-empty = "";
        label-empty-padding = 0;
        # label-empty = "%name%";
        # label-empty-foreground = foreground-dark;
        # label-empty-padding = "1";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount-0 = "/";
        label-mounted = "%{F${primary}}%mountpoint%%{F-} %free%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = foreground-dark;
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = primary;
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = foreground-dark;
      };
      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "RAM ";
        format-prefix-foreground = primary;
        label = "%percentage_used:2%%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = "CPU ";
        format-prefix-foreground = primary;
        label = "%percentage:2%%";
      };
      "network-base" = {
        type = "internal/network";
        interval = "5";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected =
          "%{F${primary}}%ifname%%{F${foreground-dark}} disconnected";
      };
      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";
        label-connected = "%{F${primary}}%ifname%%{F-} %essid% %local_ip%";
      };
      "module/eth" = {
        "inherit" = "network-base";
        interface-type = "wired";
        label-connected = "%{F${primary}}%ifname%%{F-} %local_ip%";
      };
      "module/date" = {
        type = "internal/date";
        interval = "1";
        date = "%Y-%m-%d %l:%M:%S";
        label = "%date%";
        label-foreground = primary;
      };
      "settings" = {
        screenchange-reload = "true";
        pseudo-transparency = "true";
      };
    };
  };
}
