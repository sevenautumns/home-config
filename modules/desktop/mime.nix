{ pkgs, config, host, lib, inputs, ... }:
let
  browser = [ "brave-browser.desktop" ];
  image = [ "org.gnome.eog.desktop" ];
  text = [ "visual-studio-code.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;

    "image/jpeg" = image;
    "image/png" = image;

    "text/english" = text;
    "text/x-c" = text;
    "text/x-c++" = text;
    "text/x-c++hdr" = text;
    "text/x-c++src" = text;
    "text/x-chdr" = text;
    "text/x-csrc" = text;
    "text/x-java" = text;
    "text/x-makefile" = text;
    "text/x-moc" = text;
    "text/x-pascal" = text;
    "text/x-tcl" = text;
    "text/x-tex" = text;
    "text/xml" = text;

    "x-scheme-handler/tg" = [ "userapp-Telegram Desktop-ONADH1.desktop" ];
  };
in {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = associations;
    associations.added = associations;
  };
}

#text/html=brave-browser.desktop
#x-scheme-handler/http=brave-browser.desktop
#x-scheme-handler/https=brave-browser.desktop
#x-scheme-handler/about=brave-browser.desktop
#x-scheme-handler/unknown=brave-browser.desktop
#x-scheme-handler/tg=userapp-Telegram Desktop-ONADH1.desktop
