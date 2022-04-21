{ pkgs, lib, inputs, ... }:
let
  mpv-discord-bin = pkgs.buildGoModule {
    name = "mpv-discord-bin";
    src = "${inputs.mpv-discord}/mpv-discord";
    vendorSha256 = "sha256-xe1jyWFQUD+Z4qBAVQ0SBY0gdxmi5XG9t29n3f/WKDs=";
  };
  mpv-discord = (pkgs.stdenv.mkDerivation rec {
    pname = "mpv-discord";
    version = "github";
    src = inputs.mpv-discord;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/mpv/scripts
      cp scripts/discord.lua $out/share/mpv/scripts
    '';
    passthru.scriptName = "discord.lua";

    meta = {
      homepage = "https://github.com/tnychn/mpv-discord";
      inherit version;
    };
  });
in {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    scripts = [
      pkgs.mpvScripts.mpris
      #mpv-discord 
    ];
    bindings = {
      "Ctrl+j" = "cycle secondary-sid";
      "Ctrl+J" = "cycle secondary-sid down";
    };
  };

  xdg.configFile."mpv/script-opts/discord.conf".text = ''
    key=D
    active=yes
    client_id=737663962677510245
    binary_path=${mpv-discord-bin}/bin/mpv-discord
    socket_path=/tmp/mpvsocket
    use_static_socket_path=yes
    autohide_threshold=0
  '';
}
