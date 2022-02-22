{ lib, ... }:
let
  theme = rec {
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
    nord15 = "#b48ead";

    dark0 = theme.nord0;
    dark1 = theme.nord1;
    dark2 = theme.nord2;
    dark3 = theme.nord3;

    light0 = theme.nord6;
    light1 = theme.nord5;
    light2 = theme.nord4;

    primary_ui = theme.nord8;
    primary_ui2 = theme.nord7;
    secondary_ui = theme.nord9;
    tertiary_ui = theme.nord10;

    error = theme.nord11;
    danger = theme.nord12;
    warning = theme.nord13;
    success = theme.nord14;
    uncommon = theme.nord15;
  };

in {
  options = with lib; {
    theme = mapAttrs (name: value:
      mkOption {
        type = types.str;
        default = value;
      }) theme;
    theme-non_hex = mapAttrs (name: value:
      mkOption {
        type = types.str;
        default = builtins.replaceStrings [ "#" ] [ "" ] value;
      }) theme;
  };
}
