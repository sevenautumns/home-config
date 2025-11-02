{ pkgs, ... }:
let
  version = "2.0.66";
in
{
  services.factorio = {
    enable = true;
    package = pkgs.unstable.factorio-headless.overrideAttrs (_: {
      inherit version;
      src = pkgs.fetchurl {
        url = "https://factorio.com/get-download/${version}/headless/linux64";
        name = "factorio-headless-${version}.tar.xz";
        sha256 = "sha256-8bOXbqzE4jOADTmdkABsNW+jZvXWQ0HFBMlcDLoyHAY=";
      };
    });
    public = false;
    requireUserVerification = false;
    port = 34197;
    game-name = "DinossindShit";
  };
}
