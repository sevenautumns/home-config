{ pkgs, ... }: {
  systemd.services.ror2-server = {
    description = "Risk of Rain 2 Dedicated Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      TimeoutSec = "30sec";
      ExecStart = pkgs.writeShellScript "start-ror2-server" ''
        rm -drf /var/lib/ror2/.wine || true
        ${pkgs.wineWowPackages.stable}/bin/winecfg
        sleep 5
        ${pkgs.xvfb-run}/bin/xvfb-run \
          ${pkgs.wineWowPackages.stable}/bin/wine \
          ./"Risk of Rain 2.exe"
      '';
      Restart = "on-failure";
      User = "ror2";
      Group = "users";
      WorkingDirectory = "/var/lib/ror2";
    };

    preStart = ''
      ${pkgs.steamcmd}/bin/steamcmd \
        +force_install_dir "/var/lib/ror2" \
        +@sSteamCmdForcePlatformType windows \
        +login anonymous \
        +app_update 1180760 validate \
        +quit
    '';
  };

  age.secrets.ror2 = {
    file = ../../../../secrets/ror2.age;
    path = "/var/lib/ror2/Risk of Rain 2_Data/Config/server.cfg";
    owner = "ror2";
  };

  users.users.ror2 = {
    description = "Risk of Rain 2 server service user";
    home = "/var/lib/ror2";
    createHome = true;
    homeMode = "750";
    isSystemUser = true;
    group = "users";
  };

  networking.firewall.allowedUDPPorts = [ 27000 27015 27016 ];
}
