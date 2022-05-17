{ pkgs, lib, inputs, ... }: {
  programs.mpv = {
    enable = true;
    package = with pkgs;
      (pkgs.wrapMpv
        (pkgs.mpv-unwrapped.override { vapoursynthSupport = true; }) {
          youtubeSupport = true;
        });
    config = {
      no-keepaspect-window = "";
      vo = "gpu";
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
