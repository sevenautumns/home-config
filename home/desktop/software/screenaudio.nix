{ pkgs, config, lib, inputs, ... }:
let
  screenaudio = pkgs.stdenv.mkDerivation rec {
    pname = "discord-screenaudio";
    version = "1.9.2";

    src = inputs.screenaudio;

    nativeBuildInputs = with pkgs; [
      qt6.wrapQtAppsHook
      cmake
      qt6.qtbase
      qt6.qtwebengine
      pkg-config
    ];

    buildInputs = with pkgs; [
      pipewire
    ];

    preConfigure = ''
      # version.cmake either uses git tags or a version.txt file to get app version.
      # Since cmake can't access git tags, write the version to a version.txt ourselves.
      echo "${version}" > version.txt
    '';
  };
in
{
  home.packages =
    [ screenaudio ];

}
