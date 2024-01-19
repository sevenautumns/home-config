{ pkgs, config, lib, machine, hm-firefox, ... }:
let
  host = machine.host;
  theme = config.theme;
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override {
      enableWideVine = true;
      # ungoogled = true;
    };
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # privacy badger
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
      { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # https everywhere
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # video speed controller
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
      { id = "mlpapfcfoakknnhkfpencomejbcecdfp"; } # ip domain country flag
      {
        id = "fihnjjcciajhdojfnbdddfaoknhalnja";
      } # i dont care about cookies
      # { id = "oldceeleldhonbafppcapldpdifcinji"; } # languagetool
      { id = "hjdoplcnndgiblooccencgcggcoihigg"; } # terms of service didnt read
      { id = "ljipkdpcjbmhkdjjmbbaggebcednbbme"; } # behind the overlay
    ];
  };

  #       bookmarks = [
  #         {
  #           toolbar = true;
  #           bookmarks = [
  #             {
  #               name = "YouTube";
  #               url = "https://www.youtube.com/?gl=DE&hl=de";
  #             }
  #             {
  #               name = "WaniKani";
  #               url = "https://www.wanikani.com/";
  #             }
  #             {
  #               name = "Bunpro";
  #               url = "https://bunpro.jp/";
  #             }
  #             {
  #               name = "DLR";
  #               bookmarks = [
  #                 {
  #                   name = "Mail";
  #                   url = "https://mail.dlr.de/owa/#path=/mail";
  #                 }
  #                 {
  #                   name = "Gleitzeit";
  #                   url = "https://gleitzeit.bs.dlr.de/primeweb/index.jsp";
  #                 }
  #                 {
  #                   name = "WebPostkorb";
  #                   url = "https://webpostkorb.dlr.de/";
  #                 }
  #                 {
  #                   name = "Intra";
  #                   url = "https://intranet.dlr.de/Seiten/start.aspx";
  #                 }
  #               ];
  #             }
  #           ];
  #         }
  #         {
  #           name = "Searches";
  #           bookmarks = [
  #             {
  #               name = "Duck Duck Go";
  #               keyword = ":d";
  #               url = "https://duckduckgo.com/?q=%s";
  #             }
  #             {
  #               name = "Google";
  #               keyword = ":g";
  #               url = "https://www.google.com/search?q=%s";
  #             }
  #             {
  #               name = "AUR";
  #               keyword = ":a";
  #               url = "https://aur.archlinux.org/packages/?K=%s";
  #             }
  #             {
  #               name = "Crates.io";
  #               keyword = ":c";
  #               url = "https://crates.io/search?q=%s";
  #             }
  #             {
  #               name = "Dict.cc English";
  #               keyword = ":e";
  #               url = "https://www.dict.cc/?s=%s";
  #             }
  #             {
  #               name = "Github";
  #               keyword = ":git";
  #               url = "https://github.com/search?q=%s";
  #             }
  #             {
  #               name = "Github Nix";
  #               keyword = ":gn";
  #               url =
  #                 "https://github.com/search?q=%s+language%3ANix&type=Code&ref=advsearch&l=Nix";
  #             }
  #             {
  #               name = "Github Code";
  #               keyword = ":gc";
  #               url = "https://github.com/search?q=%s&type=Code&ref=advsearch";
  #             }
  #             {
  #               name = "Github Rust";
  #               keyword = ":gr";
  #               url =
  #                 "https://github.com/search?q=%s+language%3ARust&type=Code&ref=advsearch&l=Rust";
  #             }
  #             {
  #               name = "Nixpkgs";
  #               keyword = ":np";
  #               url =
  #                 "https://search.nixos.org/packages?channel=unstable&query=%s";
  #             }
  #             {
  #               name = "Nix Options";
  #               keyword = ":no";
  #               url =
  #                 "https://search.nixos.org/options?channel=unstable&query=%s";
  #             }
  #             {
  #               name = "Nyaa";
  #               keyword = ":nyaa";
  #               url = "https://nyaa.si/?q=%s";
  #             }
  #           ];
  #         }
  #       ];
  #     };
  #   };
}
