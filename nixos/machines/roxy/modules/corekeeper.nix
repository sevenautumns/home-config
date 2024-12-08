{ config, pkgs, lib, ... }:
let
  inherit (lib.meta) getExe getExe';
  port = 8211;
  group = "corekeeper";
  user = "corekeeper";
  dataDir = "/var/lib/corekeeper";
  join = builtins.concatStringsSep " ";
in
{
  users.users.${user} = {
    inherit group;
    home = dataDir;
    createHome = true;
    isSystemUser = true;
  };
  users.groups.${group} = { };

  systemd.services.corekeeper = {
    path = with pkgs.xorg; [ libXi xorgserver ];
    # wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # EnvironmentFile = cfg.secretFile;
      ExecStartPre = join [
        "${getExe' pkgs.steamcmd "steamcmd"}"
        "+force_install_dir ${dataDir}"
        "+login anonymous"
        "+app_update 1007 validate"
        "+app_update 1963720 validate"
        "+quit"
      ];
      ExecStart = join [
        "${getExe pkgs.steam-run} ${dataDir}/_launch.sh"
      ];
      Restart = "always";
      StateDirectory = "corekeeper";
      User = user;
      WorkingDirectory = dataDir;
    };
    environment = {
      LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";
      # LD_LIBRARY_PATH = "${pkgs.glibc}/lib";
    };
  };
  hardware.graphics.enable = true;
}
