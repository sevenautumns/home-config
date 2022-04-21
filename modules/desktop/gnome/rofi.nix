{ pkgs, config, lib, ... }:
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
    extraConfig = {
      icon-theme = config.gtk.iconTheme.name;
      width = 30;
      line-margin = 10;
      lines = 6;
      columns = 2;
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
        foreground = mkLiteral theme.nord6;
        backlight = mkLiteral "#ccffeedd";
        background-color = mkLiteral "transparent";
        highlight = mkLiteral "underline bold ${theme.nord6}";
        transparent = mkLiteral "rgba(46,52,64,0)";
      };
      "window" = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "screenshot";
        padding = mkLiteral "0px";
        border = mkLiteral "0px";
        #border-radius = mkLiteral "6px";
        background-color = mkLiteral "@transparent";
        spacing = 0;
        children = mkLiteral "[mainbox]";
        orientation = mkLiteral "horizontal";
      };
      "mainbox" = {
        spacing = 0;
        children = mkLiteral "[ inputbar, message, listview ]";
      };
      "message" = {
        color = mkLiteral theme.nord0;
        padding = 5;
        border-color = mkLiteral "@foreground";
        border = mkLiteral "0px 1px 1px 1px";
        background-color = mkLiteral theme.nord9;
      };
      "inputbar" = {
        color = mkLiteral theme.nord6;
        padding = mkLiteral "11px";
        background-color = mkLiteral theme.nord1;

        border = mkLiteral "1px";
        #border-radius = mkLiteral "6px 6px 0px 0px";
        border-color = mkLiteral theme.nord6;
      };
      "entry, prompt, case-indicator" = {
        text-font = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "prompt" = { margin = mkLiteral "0px 0.3em 0em 0em"; };
      "listview" = {
        padding = mkLiteral "8px";
        #border-radius = "0px 0px 6px 6px";
        border-color = mkLiteral theme.nord6;
        border = mkLiteral "0px 1px 1px 1px";
        background-color = mkLiteral "rgba(46,52,64,1.0)";
        dynamic = false;
        columns = 2;
      };
      "element" = {
        padding = mkLiteral "3px";
        vertical-align = mkLiteral "0.5";
        #border-radius = mkLiteral "4px";
        background-color = "transparent";
        color = "@foreground";
        text-color = mkLiteral "rgb(216, 222, 233)";
      };
      "element selected.normal" = {
        background-color = mkLiteral theme.nord9;
        text-color = mkLiteral theme.nord0;
      };
      "element-text, element-icon" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "button" = {
        padding = mkLiteral "6px";
        color = mkLiteral "@foreground";
        horizontal-align = mkLiteral "0.5";

        border = mkLiteral "2px 0px 2px 2px";
        #border-radius = mkLiteral "4px 0px 0px 4px";
        border-color = mkLiteral "@foreground";
      };
      "button selected normal" = {
        border = mkLiteral "2px 0px 2px 2px";
        border-color = mkLiteral "@foreground";
      };
    };
  };
}
