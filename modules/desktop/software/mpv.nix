{ pkgs, lib, inputs, ... }: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    scripts = [ pkgs.mpvScripts.mpris ];
    bindings = {
      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };
  };
}
