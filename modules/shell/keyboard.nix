{ pkgs, config, lib, host, ... }:
let
  de = {
    layout = "de";
    variant = ''""'';
    model = "pc105";
    options = [ "caps:ctrl_modifier" "altwin:swap_alt_win" "lv3:rwin_switch" ];
  };
  de_us = {
    layout = "de";
    variant = "us";
    model = "pc105";
    options = [ "caps:ctrl_modifier" "altwin:swap_alt_win" "lv3:rwin_switch" ];
  };
  make-command = k:
    (builtins.replaceStrings [ "\n" ] [ " " ] ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap 
        -layout ${k.layout}
        -variant ${k.variant}
        -model ${k.model}
        ${(builtins.toString (builtins.map (o: "-option " + o) k.options))}
    '');
in {

  options = with lib; {
    keyboard-commands = {
      keyboard-de = mkOption {
        type = types.str;
        default = make-command de;
      };
      keyboard-de_us = mkOption {
        type = types.str;
        default = make-command de_us;
      };
    };
  };

  config = { home.keyboard = if host == "ft-ssy-sfnb" then de else de_us; };
}
