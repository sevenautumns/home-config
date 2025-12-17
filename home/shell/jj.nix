{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu;
    settings = {
      user = {
        name = "Sven Friedrich";
        email = "sven@autumnal.de";
      };
    };
  };
  programs.jjui = {
    enable = true;
  };
  programs.delta = {
    enableJujutsuIntegration = true;
  };
}
