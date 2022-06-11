{ pkgs, ... }: {
  systemd.services.satisfactory-server = {
    description = "Satisfactory Dedicated Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      TimeoutSec = "1min";
      ExecStart = ''
        ${pkgs.steam-run}/bin/steam-run \
          /var/lib/satisfactory/FactoryServer.sh \
            -multihome=192.145.45.214
      '';
      Restart = "on-failure";
      User = "satisfactory";
      Group = "users";
      WorkingDirectory = "/var/lib/satisfactory";
    };

    preStart = ''
      ${pkgs.steamcmd}/bin/steamcmd +force_install_dir "/var/lib/satisfactory" +login anonymous +app_update 1690800 validate +quit
    '';
  };

  users.users.satisfactory = {
    description = "Satisfactory server service user";
    home = "/var/lib/satisfactory";
    createHome = true;
    homeMode = "750";
    isSystemUser = true;
    group = "users";
  };

  networking.firewall.allowedUDPPorts = [ 15777 7777 15000 ];
}
