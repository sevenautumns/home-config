# *  Taken from https://github.com/Zumorica/GradientOS/blob/main/hosts/asiyah/palworld-server.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
  steam-app = "2394010";
  port = 8211;
  group = "palworld";
  user = "palworld";
  dataDir = "/var/lib/palworld";
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

  systemd.services.palworld = {
    # wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # EnvironmentFile = cfg.secretFile;
      ExecStartPre = join [
        "${getExe' pkgs.steamcmd "steamcmd"}"
        "+force_install_dir ${dataDir}"
        "+login anonymous"
        "+app_update 2394010"
        "+quit"
      ];
      ExecStart = join [
        "${getExe pkgs.steam-run} ${dataDir}/Pal/Binaries/Linux/PalServer-Linux-Shipping Pal"
        "--port ${toString port}"
        "--players ${toString 12}"
        "--useperfthreads"
        "-NoAsyncLoadingThread"
        "-UseMultithreadForDS"
      ];
      Restart = "always";
      StateDirectory = "palworld";
      User = user;
      WorkingDirectory = dataDir;
    };
    environment = {
      # linux64 directory is required by palworld.
      LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";
    };
  };
}
