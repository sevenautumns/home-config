{ pkgs, lib, inputs, ... }: {
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
    bindings = {
      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };
  };
}
