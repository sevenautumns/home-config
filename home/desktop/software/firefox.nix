{
  pkgs,
  config,
  lib,
  machine,
  hm-firefox,
  ...
}:
let
  host = machine.host;
  theme = config.theme;
in
{
  programs.browserpass.enable = true;

  programs.firefox = {
    enable = true;
    package = with pkgs; if machine.nixos then firefox else hello;
    profiles.default = {
      id = 0;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        vimium
        ublock-origin
        videospeed
        sponsorblock
        flagfox
        i-dont-care-about-cookies
        # https-everywhere
        enhanced-github
        privacy-badger
        # linkhints # less vim more links
        terms-of-service-didnt-read
        augmented-steam
        protondb-for-steam
        copy-selection-as-markdown
        behind-the-overlay-revival
        browserpass
      ];
      search = {
        force = true;
        default = "ddg";
        order = [
          "ddg"
          "google"
        ];
        engines = {
          bing.metaData.hidden = true;
          ebay.metaData.hidden = true;
          # "Google".metaData.alias = ":g";
          ddg.metaData.alias = ":d";
          "GitHub Nix" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}+language%3ANix";
                  }
                  {
                    name = "type";
                    value = "Code";
                  }
                  {
                    name = "ref";
                    value = "advsearch";
                  }
                  {
                    name = "l";
                    value = "Nix";
                  }
                ];
              }
            ];
            icon = "https://github.githubassets.com/favicons/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":gn" ];
          };
          "GitHub Code" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "Code";
                  }
                  {
                    name = "ref";
                    value = "advsearch";
                  }
                ];
              }
            ];
            icon = "https://github.githubassets.com/favicons/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":gc" ];
          };
          "GitHub Rust" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}+language%3ARust";
                  }
                  {
                    name = "type";
                    value = "Code";
                  }
                  {
                    name = "ref";
                    value = "advsearch";
                  }
                  {
                    name = "l";
                    value = "Rust";
                  }
                ];
              }
            ];
            icon = "https://github.githubassets.com/favicons/favicon.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":gr" ];
          };
          "Leta Google" = {
            urls = [
              {
                template = "https://leta.mullvad.net/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "engine";
                    value = "google";
                  }
                ];
              }
            ];
            icon = "https://leta.mullvad.net/mullvad-vpn-logo.svg";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":g" ];
          };
          "Nixpkgs" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":np" ];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":no" ];
          };
          "Crates" = {
            urls = [
              {
                template = "https://crates.io/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://crates.io/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":c" ];
          };
          "Dict.cc English" = {
            urls = [
              {
                template = "https://www.dict.cc/";
                params = [
                  {
                    name = "s";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://www4.dict.cc/img/favicons/favicon4.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":e" ];
          };
          "Nyaa" = {
            urls = [
              {
                template = "https://nyaa.si/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://nyaa.si/static/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":nyaa" ];
          };
        };
      };

      settings = {
        "extensions.pocket.enabled" = false;

        "extensions.autoDisableScopes" = 0;

        "general.smoothScroll" = false;

        "browser.search.defaultenginename" = "ddg";
        "browser.search.selectedEngine" = "ddg";
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
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

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
