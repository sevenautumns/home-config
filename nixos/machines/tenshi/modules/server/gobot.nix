{ pkgs, config, inputs, lib, ... }:
let
  buildGoModule = pkgs.buildGoModule.override { go = pkgs.unstable.go_1_18; };
  gobot = buildGoModule {
    name = "gobot";
    src = inputs.gobot;
    vendorSha256 = "sha256-USgvi2VNrTqEJVRg38rugoTZYQarHnQtBdGcU94cFtc=";

    meta = with lib; {
      description = "Discord Music Bot written in Go";
      homepage = "https://github.com/c0nvulsiv3/gobot";
      license = licenses.gpl3;
      platforms = platforms.unix;
    };
  };
in {

  systemd.services.gobot = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "gobot";
      ExecStart = "${gobot}/bin/gobot -config /var/lib/gobot/config.json";
      Restart = "always";
      RestartSec = 2;
      # Creates /var/lib/gobot
      StateDirectory = "gobot";
    };
  };

  age.secrets.gobot = {
    file = ../../../../../secrets/gobot.age;
    path = "/var/lib/gobot/config.json";
    owner = "gobot";
  };

  users.users.gobot = {
    uid = 1025;
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/gobot";
    description = "GoBot Service User";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp autumnal@neesama"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6 frie_sv@ft-ssy-sfnb"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrXLTP6n3DEhDwMX/69MMenKeuEsA/k0WkmAE3DvOaN hendrikbertram@protonmail.com"
    ];
  };
}
