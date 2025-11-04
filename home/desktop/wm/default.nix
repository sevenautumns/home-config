{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./sway.nix
    ./mako.nix
  ];

  services.kanshi.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "niri/workspaces"
          "niri/mode"
          "wlr/taskbar"
        ];

        modules-center = [
          "niri/window"
        ];

        modules-right = [
          "cpu"
          "memory"
          "pulseaudio"
          "temperature"
          "clock"
        ];

        "niri/workspaces" = {
          all-outputs = true;
        };

        "cpu" = {
          format = "CPU {usage}%";
          tooltip = true;
          interval = 5;
        };

        "memory" = {
          format = "RAM {used:0.1f}G";
          tooltip = true;
          interval = 5;
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = "Muted";
          on-click = "pavucontrol";
        };

        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "temperature" = {
          format = "{temperatureC}°C";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C";
        };
      };
    };
  };

  home.packages = with pkgs; [
    niri
    fuzzel
    xwayland-satellite
    wdisplays
    xdg-terminal-exec-mkhl
    dmenu-wayland
    ironbar
    xwayland
    xdg-utils
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "94e2d5ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "94e2d5ff";
        counter = "7f849cff";
        border = "94e2d5ff";
      };
    };
  };
}
