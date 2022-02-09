{ pkgs, lib, config, host, ... }:
let
  mpris-python-packages = python-packages:
    with python-packages; [
      numpy
      requests
      dbus-python
      pygobject3
    ];
  mpris-python = pkgs.python3.withPackages mpris-python-packages;

  home.packages = [
    # Needed for pactl
    pkgs.pulseaudio
    pkgs.pavucontrol
  ];

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
  my-polybar = pkgs.polybar.override {
    i3GapsSupport = true;
    alsaSupport = true;
    pulseSupport = true;
    iwSupport = true;
    githubSupport = true;
    jsoncpp = pkgs.jsoncpp;
  };
in {
  xdg.configFile."polybar/scripts/pulseaudio-control.bash".source =
    ./pulseaudio-control.bash;
  xdg.configFile."polybar/scripts/player-mpris-tail.py".source =
    ./player-mpris-tail.py;

  services.polybar = {
    enable = true;
    package = my-polybar;
    script = ''
      export PATH=$PATH:/usr/bin:/run/current-system/sw/bin:${config.home.homeDirectory}/.nix-profile/bin
      ${my-polybar}/bin/polybar -q main &
    '';
    settings = {
      "settings".format.padding = 1;
      "bar/main" = {
        bottom = false;
        fixed.center = false;
        width = "100%";
        border = {
          size = 4;
          color = nord0;
        };
        background = nord0;
        foreground = nord6;
        line-size = 0;
        padding = {
          left = 8;
          right = 3;
        };
        module.margin = {
          left = 1;
          right = 1;
        };
        font = {
          # The most beautiful Font
          "0" = "Roboto:style=Bold:pixelsize=11;3";
          # Meh, but it got a nice icon for ram
          "1" = "Font Awesome 5 Free:style=Solid:size=10;2";
          # Used for i3-module arcs
          "2" = "FiraCode Nerd Font:size=17;4";
          # Fallback Font for Japanese Writing
          "3" = "Sarasa UI J:style=Bold:size=11;3";
          # Nerd Font Icons for all
          "4" = "FiraCode Nerd Font:size=13;3.5";
          # Some Monospace Roboto for padding memory and cpu numbers
          "5" = "RobotoMono Nerd Font:style=Bold:pixelsize=11;3";
        };
        modules = {
          left = "i3";
          center = "player-mpris-tail";
          right = if host == "neesama" then
              "memory cpu pulseaudio-control date time"
            else if host == "ft-ssy-sfnb" then
              "memory cpu pulseaudio-control battery date time"
            # This last one is for failing if the system is not defined
            else
              0;
        };
        tray = {
          position = "right";
          detached = false;
          padding = 2;
        };
        wm.restack = "i3";
        enable.ipc = true;
      };
      "module/sep" = {
        type = "custom/text";
        content = " ";
      };
      "module/i3" = {
        type = "internal/i3";
        index.sort = true;
        enable-click = true;
        enable-scroll = false;
        wrapping.scroll = false;
        format = "<label-state> <label-mode>";
        label = {
          mode =
            "%{F#ebcb8b}%{T3}%{T-}%{F-}%{F#2e3440 B#ebcb8b}%mode%%{F- B-}%{F#ebcb8b}%{T3}%{T-}%{F-}";
          # focused = Active workspace on focused monitor
          focused =
            "%{F#81a1c1}%{T3}%{T-}%{F-}%{B#81a1c1}%index%%{B-}%{F#81a1c1}%{T3}%{T-}%{F-}";
          # unfocused = Inactive workspace on any monitor
          unfocused =
            "%{F#3b4252}%{T3}%{T-}%{F-}%{B#3b4252}%index%%{B-}%{F#3b4252}%{T3}%{T-}%{F-}";
          # visible = Active workspace on unfocused monitor
          visible =
            "%{F#4c566a}%{T3}%{T-}%{F-}%{B#4c566a}%index%%{B-}%{F#4c566a}%{T3}%{T-}%{F-}";
          # urgent = Workspace with urgency hint set
          urgent =
            "%{F#bf616a}%{T3}%{T-}%{F-}%{B#bf616a}%index%%{B-}%{F#bf616a}%{T3}%{T-}%{F-}";
        };
      };
      "module/memory" = {
        type = "internal/memory";
        internal = 2;
        format = "<label>";
        format-prefix = "%{T2}︁ %{T-}";
        format-foreground = nord14;
        label = "%mb_used%";
        label-minlen = 9;
        label-font = 6;
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 1;
        format-prefix = "%{T5} %{T-}";
        format-foreground = nord9;
        label = "%percentage%%";
        label-minlen = 4;
        label-font = 6;
      };
      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "  %h %d %a";
        date-alt = "  %Y-%m-%d";
        format-foreground = nord8;
        label = "%date%";
      };
      "module/time" = {
        type = "internal/date";
        interval = 1;
        time = "  %I:%M %p";
        time-alt = " %H:%M:%S";
        format-foreground = nord13;
        label = "%time%";
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 5;
      };
      "module/player-mpris-tail" = {
        type = "custom/script";
        # TODO link player mpris tail?
        exec =
          "${mpris-python}/bin/python3 ~/.config/polybar/scripts/player-mpris-tail.py -f '{artist} - {title}'";
        tail = true;
        format-foreground = nord12;
        format-padding = 2;
      };
      "module/pulseaudio-control" = {
        type = "custom/script";
        tail = true;
        format-foreground = nord15;
        format-padding = 2;
        #"${pkgs.bash}/bin/bash ~/.config/polybar/scripts/pulseaudio-control.bash --sink-nicknames-from 'node.name' --sink-nickname 'alsa_output.pci-0000_0c_00.4.analog-stereo:%{T5}蓼%{T-}' --sink-nickname 'alsa_output.pci-0000_0b_00.4.analog-stereo:%{T5}蓼%{T-}' --sink-nickname 'alsa_output.usb-Yamaha_Corporation_Steinberg_UR12-00.analog-stereo:%{T5}%{T-}' --sink-nickname 'alsa_output.usb-Yamaha_Corporation_Steinberg_UR12-00.iec958-stereo:%{T5}%{T-}' listen";
        exec = 
          "${pkgs.bash}/bin/bash ~/.config/polybar/scripts/pulseaudio-control.bash --sink-nicknames-from 'node.name' --format '$SINK_NICKNAME \${VOL_LEVEL}%' --sink-nickname '*pci*analog-stereo:%{T5}蓼%{T-}' --sink-nickname '*Yamaha*:%{T5}%{T-}' listen";
        click = {
          # this is also copied to i3-config
          left =
            "${pkgs.bash}/bin/bash ~/.config/polybar/scripts/pulseaudio-control.bash --sink-nicknames-from 'node.name' --sink-blacklist '*hdmi*,easyeffects*' next-sink";
          #"${pkgs.bash}/bin/bash ~/.config/polybar/scripts/pulseaudio-control.bash --sink-nicknames-from 'node.name' --sink-blacklist 'alsa_output.pci-0000_0a_00.1.hdmi-stereo,alsa_output.pci-0000_09_00.1.hdmi-stereo,alsa_output.pci-0000_09_00.1.hdmi-stereo-extra2,easyeffects_sink,alsa_output.pci-0000_0a_00.1.hdmi-stereo-extra2' next-sink";
          # With pactl set-card-profile we can force the audio out to be available
          right =
            "${pkgs.pulseaudio}/bin/pactl set-card-profile alsa_card.pci-0000_0b_00.4 output:analog-stereo && ${pkgs.pulseaudio}/bin/pactl set-card-profile alsa_output.pci-0000_0c_00.4 output:analog-stereo";
        };
      };
      "module/network" = {
        type = "internal/network";
        interface = "enp5s0";
        format-connected-foreground = nord11;
        format-connected = "<label-connected>";
        label-connected = "%{T5}ﰬ%{T-}%downspeed:9% %{T5}ﰵ%{T-}%upspeed:9%";
      };
    };
  };
}
