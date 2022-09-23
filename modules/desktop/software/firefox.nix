{ pkgs, config, lib, machine, hm-firefox, ... }:
let
  host = machine.host;
  theme = config.theme;
in {
  programs.firefox = {
    enable = true;
    package = with pkgs; stable.firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      vimium
      ublock-origin
      bitwarden
      videospeed
      sponsorblock
      flagfox
      i-dont-care-about-cookies
      https-everywhere
      enhanced-github
      privacy-badger
      languagetool
      # linkhints # less vim more links
      terms-of-service-didnt-read
      rust-search-extension
      augmented-steam
      protondb-for-steam
      copy-selection-as-markdown
      behind-the-overlay-revival
    ];
    profiles.default = {
      id = 0;

      #search = {
      #  force = true;
      #  default = "DuckDuckGo";
      #  order = [ "DuckDuckGo" "Google" ];
      #  engines = {
      #    "Bing".metaData.hidden = true;
      #    "eBay".metaData.hidden = true;
      #    "Google".metaData.alias = "@g";
      #    "DuckDuckGo".metaData.alias = "@d";
      #    "GitHub Nix" = {
      #      urls = [{
      #        template = "https://github.com/search";
      #        params = [
      #          { name = "q"; value = "{searchTerms}+language%3ANix"; }
      #          { name = "type"; value = "Code"; }
      #          { name = "ref"; value = "advsearch"; }
      #          { name = "l"; value = "Nix"; }
      #        ];
      #      }];
      #      icon = "${pkgs.fetchurl {
      #        url = "https://github.githubassets.com/favicons/favicon.svg";
      #        sha256 = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
      #      }}";
      #      definedAliases = [ "@gn" ];
      #    };
      #  };
      #};

      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "YouTube";
              url = "https://www.youtube.com/?gl=DE&hl=de";
            }
            {
              name = "WaniKani";
              url = "https://www.wanikani.com/";
            }
            {
              name = "Bunpro";
              url = "https://bunpro.jp/";
            }
            {
              name = "DLR";
              bookmarks = [
                {
                  name = "Mail";
                  url = "https://mail.dlr.de/owa/#path=/mail";
                }
                {
                  name = "Gleitzeit";
                  url = "https://gleitzeit.bs.dlr.de/primeweb/index.jsp";
                }
                {
                  name = "WebPostkorb";
                  url = "https://webpostkorb.dlr.de/";
                }
                {
                  name = "Intra";
                  url = "https://intranet.dlr.de/Seiten/start.aspx";
                }
              ];
            }
          ];
        }
        {
          name = "Searches";
          bookmarks = [
            {
              name = "Duck Duck Go";
              keyword = ":d";
              url = "https://duckduckgo.com/?q=%s";
            }
            {
              name = "Google";
              keyword = ":g";
              url = "https://www.google.com/search?q=%s";
            }
            {
              name = "AUR";
              keyword = ":a";
              url = "https://aur.archlinux.org/packages/?K=%s";
            }
            {
              name = "Crates.io";
              keyword = ":c";
              url = "https://crates.io/search?q=%s";
            }
            {
              name = "Dict.cc English";
              keyword = ":e";
              url = "https://www.dict.cc/?s=%s";
            }
            {
              name = "Github";
              keyword = ":git";
              url = "https://github.com/search?q=%s";
            }
            {
              name = "Github Nix";
              keyword = ":gn";
              url =
                "https://github.com/search?q=%s+language%3ANix&type=Code&ref=advsearch&l=Nix";
            }
            {
              name = "Github Code";
              keyword = ":gc";
              url = "https://github.com/search?q=%s&type=Code&ref=advsearch";
            }
            {
              name = "Github Rust";
              keyword = ":gr";
              url =
                "https://github.com/search?q=%s+language%3ARust&type=Code&ref=advsearch&l=Rust";
            }
            {
              name = "Nixpkgs";
              keyword = ":np";
              url =
                "https://search.nixos.org/packages?channel=unstable&query=%s";
            }
            {
              name = "Nix Options";
              keyword = ":no";
              url =
                "https://search.nixos.org/options?channel=unstable&query=%s";
            }
            {
              name = "Nyaa";
              keyword = ":nyaa";
              url = "https://nyaa.si/?q=%s";
            }
          ];
        }
      ];

      settings = {
        "extensions.pocket.enabled" = false;

        "extensions.autoDisableScopes" = 0;

        "general.smoothScroll" = false;

        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.selectedEngine" = "DuckDuckGo";
        #"browser.search.region" = "US";fi
        #"browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = true;
        "webgl.disabled" = false;

        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.toolbars.bookmarks.showOtherBookmarks" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;

        "browser.uidensity" = 1;

        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;

        "signon.rememberSignons" = false;

        # Disable legacy webrtc sharing icon
        "privacy.webrtc.legacyGlobalIndicator" = false;
        "privacy.webrtc.hideGlobalIndicator" = true;

        # Font config
        "font.name.monospace.ja" = "Sarasa Mono J";
        "font.name.sans-serif.ja" = "Sarasa UI J";
        "font.name.serif.ja" = "Sarasa UI J";

        # DLR Auth
        "network.negotiate-auth.trusted-uris" = "dlr.de";
        "network.automatisc-ntlm-auth.trusted-uris" = "dlr.de";
        "security.identityblock.show_extended_validation" = true;
      };
    };
  };
}
