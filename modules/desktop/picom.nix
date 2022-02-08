{ pkgs, ... }: {
  services.picom = {
    #    package = pkgs.nur.repos.reedrw.picom-next-ibhagwan;

    enable = true;
    backend = "xrender";
    vSync = false;
    experimentalBackends = true;
    refreshRate = 240;
    shadow = true;
    #shadowOffsets = [ (-12) (-6) ];
    shadowOffsets = [ (-5) (-5) ];
    shadowOpacity = "0.6";
    shadowExclude = [
      "class_g ?= 'i3-frame'"
      "class_g ?= 'Polybar'"
      "_GTK_FRAME_EXTENTS@:c"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[1]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[2]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[3]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[4]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[5]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[6]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[7]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[8]:32a = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[9]:32a = '_NET_WM_STATE_FULLSCREEN'"
    ];
    extraOptions = ''
      unredir-if-possible = true;
      detect-transient = true;
      detect-client-leader = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      #      "use-damage" = false;

      # Shadow
      shadow-radius = 20;
      shadow-ignore-shape = true;

      #Blur
      #      "blur-method" = "dual_kawase";
      blur-strength = 6;
      blur-background = true;
      blur-kern = "7x7box";
      blur-background-exclude = [ 
        "window_type = 'desktop'" 
      ];
    '';
    opacityRule = [
      "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[5]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[6]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[7]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[8]:32a *= '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[9]:32a *= '_NET_WM_STATE_HIDDEN'"
    ];
  };
}
