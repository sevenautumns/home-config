{ pkgs, lib, inputs, ... }: {
  programs.mpv = {
    enable = true;
    package = with pkgs;
      (pkgs.unstable.wrapMpv
        # (pkgs.unstable.mpv-unwrapped.override { vapoursynthSupport = true; })
        pkgs.unstable.mpv-unwrapped
        {
          youtubeSupport = true;
        });
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
