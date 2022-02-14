{ pkgs, config, host, lib, inputs, ... }:
let
  browser = [ "brave-browser.desktop" ];
  image = [ "org.gnome.eog.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;

    "image/jpeg" = image;
    "image/png" = image;

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
