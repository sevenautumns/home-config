{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
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
    de-apple = layouts.de // { options = layouts.de.options ++ apple-options; };
    de_us-apple = layouts.de_us // {
      options = layouts.de_us.options ++ apple-options;
    };
  };
  commands = lib.attrsets.mapAttrsToList (name: l:
    pkgs.writeShellScriptBin ("keyboard-" + name) ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap \
        -layout ${l.layout} \
        -variant ${l.variant} \
        -model ${l.model} \
        ${(builtins.toString (builtins.map (o: "-option " + o) l.options))}
    '') layouts;
in with layouts; {
  home.keyboard =
    if host == "neesama" then layouts.de_us-apple else layouts.de_us;
  home.packages = commands;
}
