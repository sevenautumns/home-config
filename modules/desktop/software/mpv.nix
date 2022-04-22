{ pkgs, lib, inputs, ... }: {
  programs.mpv = {
    enable = true;
    package = with pkgs; (fixGL mpv);
    config = {
      no-keepaspect-window = "";
      vo = "gpu";
      hwdec = "auto";
    };
    bindings = {
      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };
  };
}
