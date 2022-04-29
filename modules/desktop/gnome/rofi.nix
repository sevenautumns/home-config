{ pkgs, config, lib, inputs, ... }:
let theme = config.theme;
in {
  # TODO Terminal?

  services.sxhkd.keybindings = {
    "super + d" = "rofi -no-lazy-grab -show drun -modi drun";
    "super + t" = "rofi -show window -modi window";
    #"XF86Calculator" = "rofi -show calc -mode calc";
  };

  programs.rofi = {
    enable = true;
    font = "FiraCode Nerd Font 11";
    plugins = [ pkgs.rofi-calc ];
    #theme = "${inputs.rofi-themes}/1080p/launchers/misc/kde_krunner.rasi";
    extraConfig = {
      icon-theme = config.gtk.iconTheme.name;
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
      show-icons = true;
      modi = "drun,window,run,ssh,calc";
    };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background = mkLiteral "#2f3541F2";
        background-alt = mkLiteral "#00000000";
        background-bar = mkLiteral "#f2f2f215";
        foreground = mkLiteral "#f2f2f2EE";
        accent = mkLiteral "#3DAEE966";
        #foreground = mkLiteral theme.nord6;
        #backlight = mkLiteral "#ccffeedd;
        #background-color = mkLiteral "transparent";
        #highlight = mkLiteral "underline bold ${theme.nord6}";
        #transparent = mkLiteral "rgba(46,52,64,0)";
      };
      "window" = {
        transparency = "real";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0px";
        border-color = mkLiteral "@border";
        border-radius = mkLiteral "12px";
        width = mkLiteral "40%";
        location = mkLiteral "center";
        x-offset = 0;
        y-offset = 0;
      };
      "prompt" = {
        enabled = true;
        padding = mkLiteral "0.30% 1% 0% -0.5%";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        font = "FantasqueSansMono Nerd Font 12";
      };

      "entry" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        placeholder-color = mkLiteral "@foreground";
        expand = true;
        horizontal-align = 0;
        placeholder = "Search";
        padding = mkLiteral "0.10% 0% 0% 0%";
        blink = true;
      };

      "inputbar" = {
        children = [ (mkLiteral "prompt") (mkLiteral "entry") ];
        background-color = mkLiteral "@background-bar";
        text-color = mkLiteral "@foreground";
        expand = false;
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@accent";
        margin = mkLiteral "0% 0% 0% 0%";
        padding = mkLiteral "1.5%";
      };

      "listview" = {
        background-color = mkLiteral "@background-alt";
        columns = 5;
        lines = 3;
        spacing = mkLiteral "0%";
        cycle = false;
        dynamic = true;
        layout = mkLiteral "vertical";
      };

      "mainbox" = {
        background-color = mkLiteral "@background-alt";
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "0% 0% 0% 0%";
        border-color = mkLiteral "@accent";
        children = [ (mkLiteral "inputbar") (mkLiteral "listview") ];
        spacing = mkLiteral "2%";
        padding = mkLiteral "2% 1% 2% 1%";
      };

      "element" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "vertical";
        border-radius = mkLiteral "0%";
        padding = mkLiteral "2% 0% 2% 0%";
      };

      "element-icon" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        horizontal-align = mkLiteral "0.5";
        vertical-align = mkLiteral "0.5";
        size = mkLiteral "64px";
        border = mkLiteral "0px";
      };

      "element-text" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        expand = true;
        horizontal-align = mkLiteral "0.5";
        vertical-align = mkLiteral "0.5";
        margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
      };

      "element selected" = {
        background-color = mkLiteral "@background-bar";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@accent";
      };
    };
  };
}
