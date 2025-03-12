{
  pkgs,
  lib,
  machine,
  inputs,
  ...
}:
let
  mpv-package =
    with pkgs;
    (pkgs.mpv-unwrapped.override { vapoursynthSupport = true; }) {
      youtubeSupport = true;
    };

in
{
  programs.mpv = {
    enable = true;
    package =
      with pkgs;
      pkgs.mpv.override {
        youtubeSupport = true;
      };
    config = {
      no-keepaspect-window = "";
      #vo = "gpu";
      volume = 70;
      hwdec = "auto";
    };
    bindings = {
      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };
    profiles = {
      svp = {
        input-ipc-server = "/tmp/mpvsocket";
        hr-seek-framedrop = "no";
        resume-playback = "no";
      };
    };
  };
}
