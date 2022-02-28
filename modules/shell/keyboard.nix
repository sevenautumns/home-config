{ pkgs, config, lib, host, ... }:
let
  apple-options = [ "altwin:swap_alt_win" "lv3:rwin_switch" ];
  layouts = {
    de = {
      layout = "de";
      variant = ''""'';
      model = "pc105";
      options = [ "caps:ctrl_modifier" ];
    };
    de_us = {
      layout = "de";
      variant = "us";
      model = "pc105";
      options = [ "caps:ctrl_modifier" ];
    };
    de-apple = { options = layouts.de.options ++ apple-options; } // layouts.de;
    de_us-apple = {
      options = layouts.de_us.options ++ apple-options;
    } // layouts.de_us;
  };
in {

  options = with lib; {
    keyboard-commands = lib.attrsets.mapAttrs' (name: l:
      lib.attrsets.nameValuePair ("keyboard-" + name) (mkOption {
        type = types.str;
        default = (builtins.replaceStrings [ "\n" ] [ " " ] ''
          ${pkgs.xorg.setxkbmap}/bin/setxkbmap 
            -layout ${l.layout}
            -variant ${l.variant}
            -model ${l.model}
            ${(builtins.toString (builtins.map (o: "-option " + o) l.options))}
        '');
      })) layouts;
  };

  config = with layouts; {
    home.keyboard =
      if host == "ft-ssy-sfnb" then layouts.de else layouts.de_us-apple;
  };
}
