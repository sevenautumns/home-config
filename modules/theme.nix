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
        nord11_sat = "#e53b4b";
        nord12_sat = "#ec7854";
        nord13_sat = "#f7cf7f";
        nord14_sat = "#a0e565";
        nord15_sat = "#e161c9";
        
        dark0 = theme.nord0;
        dark1 = theme.nord1;
        dark2 = theme.nord2;
        dark3 = theme.nord3;

        light0 = theme.nord6;
        light1 = theme.nord5;
        light2 = theme.nord4;

        blue_green = theme.nord7;
        blue_light = theme.nord8;
        blue = theme.nord9;
        blue_dark = theme.nord10;

        red = theme.nord11;
        orange = theme.nord12;
        yellow = theme.nord13;
        green = theme.nord14;
        pink = theme.nord15;

        red_sat = theme.nord11_sat;
        orange_sat = theme.nord12_sat;
        yellow_sat = theme.nord13_sat;
        green_sat = theme.nord14_sat;
        pink_sat = theme.nord15_sat;
    };


in {
    options = {
        theme = lib.mapAttrs(name: value: 
            lib.mkOption {
                type = lib.types.str;
                default = value;
            }) theme;
        theme-non_hex = lib.mapAttrs(name: value: 
            lib.mkOption {
                type = lib.types.str;
                default = builtins.replaceStrings [ "#" ] [ "" ] value;
            }) theme;
    };
}