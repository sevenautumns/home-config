{ pkgs, config, lib, ... }:
let
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
in {
  # TODO use global colors like https://github.com/minijackson/nixos-config/blob/4259ed78426537d3eaab25366b15cf3783441e6b/home.nix
  # TODO Calc & emoji?
  # TODO Terminal?
  programs.rofi = {
    enable = true;
    font = "FiraCode Nerd Font 11";
    plugins = [ pkgs.rofi-calc ];
    extraConfig = {
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
        foreground = mkLiteral nord6;
        backlight = mkLiteral "#ccffeedd";
        background-color = mkLiteral "transparent";
        highlight = mkLiteral "underline bold ${nord6}";
        transparent = mkLiteral "rgba(46,52,64,0)";
      };
      "window" = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        transparency = "screenshot";
        padding = mkLiteral "0px";
        border = mkLiteral "0px";
        border-radius = mkLiteral "6px";
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
        color = mkLiteral nord0;
        padding = 5;
        border-color = mkLiteral "@foreground";
        border = mkLiteral "0px 1px 1px 1px";
        background-color = mkLiteral nord9;
      };
      "inputbar" = {
        color = mkLiteral nord6;
        padding = mkLiteral "11px";
        background-color = mkLiteral nord1;

        border = mkLiteral "1px";
        border-radius = mkLiteral "6px 6px 0px 0px";
        border-color = mkLiteral nord6;
      };
      "entry, prompt, case-indicator" = {
        text-font = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "prompt" = { margin = mkLiteral "0px 0.3em 0em 0em"; };
      "listview" = {
        padding = mkLiteral "8px";
        border-radius = "0px 0px 6px 6px";
        border-color = mkLiteral nord6;
        border = mkLiteral "0px 1px 1px 1px";
        background-color = mkLiteral "rgba(46,52,64,0.9)";
        dynamic = false;
        columns = 2;
      };
      "element" = {
        padding = mkLiteral "3px";
        vertical-align = mkLiteral "0.5";
        border-radius = mkLiteral "4px";
        background-color = "transparent";
        color = "@foreground";
        text-color = mkLiteral "rgb(216, 222, 233)";
      };
      "element selected.normal" = {
        background-color = mkLiteral nord9;
        text-color = mkLiteral nord0;
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
        border-radius = mkLiteral "4px 0px 0px 4px";
        border-color = mkLiteral "@foreground";
      };
      "button selected normal" = {
        border = mkLiteral "2px 0px 2px 2px";
        border-color = mkLiteral "@foreground";
      };
    };
  };
}
