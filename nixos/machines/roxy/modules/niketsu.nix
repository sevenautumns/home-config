{ pkgs, config, inputs, lib, ... }:
let
  system = pkgs.system;
  niketsu = inputs.niketsu.packages.${system}.niketsu-server;
in {
  systemd.services.niketsu = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "niketsu";
      ExecStart = "${niketsu}/bin/niketsu-server";
      Restart = "always";
      RestartSec = 2;
      WorkingDirectory = "/var/lib/niketsu";
    };
  };

  networking.firewall.allowedTCPPorts = [ 7766 ];

  age.secrets.niketsu = {
    file = ../../../../secrets/niketsu.age;
    path = "/var/lib/niketsu/server/config.toml";
    owner = "niketsu";
  };

  users.users.niketsu = {
    uid = 1025;
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/var/lib/niketsu";
    description = "Niketsu Service User";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp autumnal@neesama"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6 frie_sv@ft-ssy-sfnb"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrXLTP6n3DEhDwMX/69MMenKeuEsA/k0WkmAE3DvOaN hendrikbertram@protonmail.com"
    ];
  };

  security.sudo.extraRules = [{
    users = [ "niketsu" ];
    commands = [{
      command = "${pkgs.systemd}/bin/systemctl restart niketsu";
      options = [ "NOPASSWD" ];
    }];
  }];
}
