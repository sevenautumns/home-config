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
}
