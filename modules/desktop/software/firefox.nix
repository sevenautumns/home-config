{ pkgs, config, lib, machine, ... }:
let
  host = machine.host;
  theme = config.theme;
in {
  programs.firefox = {
    enable = true;
    package = with pkgs; stable.firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      bitwarden
      videospeed
      sponsorblock
    ];
    profiles.default = {
      id = 0;

      bookmarks = {
        "Duck Duck Go" = {
          keyword = ":d";
          url = "https://duckduckgo.com/?q=%s";
        };
        "Google" = {
          keyword = ":g";
          url = "https://www.google.com/search?q=%s";
        };
        "AUR" = {
          keyword = ":a";
          url = "https://aur.archlinux.org/packages/?K=%s";
        };
        "Crates.io" = {
          keyword = ":c";
          url = "https://crates.io/search?q=%s";
        };
        "Dict.cc English" = {
          keyword = ":e";
          url = "https://www.dict.cc/?s=%s";
        };
        "Github" = {
          keyword = ":git";
          url = "https://github.com/search?q=%s";
        };
        "Github Nix" = {
          keyword = ":gn";
          url =
            "https://github.com/search?q=%s+language%3ANix&type=Code&ref=advsearch&l=Nix";
        };
        "Nixpkgs" = {
          keyword = ":np";
          url =
            "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=%s";
        };
        "Nix Options" = {
          keyword = ":no";
          url =
            "https://search.nixos.org/options?channel=21.11&from=0&size=50&sort=relevance&type=packages&query=%s";
        };
        "Nyaa" = {
          keyword = ":nyaa";
          url = "https://nyaa.si/?q=%s";
        };
        "YouTube".url = "https://www.youtube.com/?gl=DE&hl=de";
        "WaniKani".url = "https://www.wanikani.com/";
      };
      settings = {
        "extensions.autoDisableScopes" = 0;

        #"browser.search.defaultenginename" = "Startpage.com - English";
        #"browser.search.selectedEngine" = "Startpage.com - English";
        #"browser.urlbar.placeholderName" = "Startpage.com - English";
        #"browser.search.region" = "US";
        #"browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = true;
        "webgl.disabled" = false;
        #"services.sync.username" = "stefan-machmeier@outlook.com";

        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "always";

        "browser.uidensity" = 1;
        #"browser.search.openintab" = true;

        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;

        "signon.rememberSignons" = false;

        # Font config
        "font.name.monospace.ja" = "Sarasa Mono J";
        "font.name.sans-serif.ja" = "Sarasa UI J";
        "font.name.serif.ja" = "Sarasa UI J";
      };
    };
  };
}
