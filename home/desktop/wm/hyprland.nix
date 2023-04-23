{ pkgs, config, machine, lib, inputs, ... }: {
  imports = [ ./rofi.nix ];

  home.packages = with pkgs; [
    # pkgs.swaybg
  ];

  wayland.windowManager.hyprland = {

    enable = true;
    package = pkgs.hyprland;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    systemdIntegration = false;
    nvidiaPatches = false;

    extraConfig = ''
      monitor = HDMI-A-1, 3840x2160@120, 0x0, 1
      monitor = DP-3, 3840x2160@60, 3840x0, 2
      monitor = DP-1, 1920x1080@240, 5760x0, 1

      exec-once = ${pkgs.swaybg}/bin/swaybg --image ~/Pictures/Wallpaper/Autumn.png
      exec-once = waybar

      input {
        kb_layout = de
        kb_variant = us
        kb_model = pc105
        kb_options caps:escape
        numlock_by_default = 1
      }

      bind = SUPER, Return, exec, alacritty
      bind = SUPER, C, killactive,
      bind = SUPER, w, exec, firefox
      # bind = SUPER, d, exec, wofi --show drun
      bind = SUPER, z, togglegroup
      bind = SUPER, SPACE, togglefloating
      bind = SUPER, f, fullscreen
      bind = SUPER SHIFT, R, exec, hyprctl reload

      bind = SUPER, d, exec, rofi -no-lazy-grab -show drun -modi drun
      # bind = SUPER, t, exec, rofi -show window -modi window
      bind = SUPER, p, exec, rofi-pass
      
      bindm = SUPER,mouse:272,movewindow
      bindm = SUPER,mouse:273,resizewindow

      bind = SUPER, LEFT, movefocus, l
      bind = SUPER, RIGHT, movefocus, r
      bind = SUPER, UP, movefocus, u
      bind = SUPER, DOWN, movefocus, d

      bind = SUPER ALT, RIGHT, changegroupactive, f
      bind = SUPER ALT, LEFT, changegroupactive, b
      bind = SUPER SHIFT ALT, LEFT, moveintogroup, l
      bind = SUPER SHIFT ALT, RIGHT, moveintogroup, r
      bind = SUPER SHIFT ALT, UP, moveintogroup, u
      bind = SUPER SHIFT ALT, DOWN, moveintogroup, d
      bind = SUPER, x, moveoutofgroup
      
      bind = SUPER SHIFT, LEFT, movewindow, l
      bind = SUPER SHIFT, RIGHT, movewindow, r
      bind = SUPER SHIFT, UP, movewindow, u
      bind = SUPER SHIFT, DOWN, movewindow, d

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      bind = SUPER, 87, workspace, 1
      bind = SUPER, 88, workspace, 2
      bind = SUPER, 89, workspace, 3
      bind = SUPER, 83, workspace, 4
      bind = SUPER, 84, workspace, 5
      bind = SUPER, 85, workspace, 6
      bind = SUPER, 79, workspace, 7
      bind = SUPER, 80, workspace, 8
      bind = SUPER, 81, workspace, 9
      bind = SUPER, 90, workspace, 10
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10
      bind = SUPER SHIFT, 87, movetoworkspace, 1
      bind = SUPER SHIFT, 88, movetoworkspace, 2
      bind = SUPER SHIFT, 89, movetoworkspace, 3
      bind = SUPER SHIFT, 83, movetoworkspace, 4
      bind = SUPER SHIFT, 84, movetoworkspace, 5
      bind = SUPER SHIFT, 85, movetoworkspace, 6
      bind = SUPER SHIFT, 79, movetoworkspace, 7
      bind = SUPER SHIFT, 80, movetoworkspace, 8
      bind = SUPER SHIFT, 81, movetoworkspace, 9
      bind = SUPER SHIFT, 90, movetoworkspace, 10

      general {
        gaps_in = 3
        gaps_out = 6
      }
    '';
  };

  services.clipman.enable = true;
  # programs.waybar

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = pkgs.waybar-hyprland;

    settings = {
      mainBar = {
        modules-left = [ "wlr/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [  "pulseuadio" "cpu" "memory" "network" "tray" "clock" ];

        "wlr/workspaces" = {
          on-click = "activate";
        };
      };
    };

  };

  programs.wofi = {
    enable = true;
  };
}
