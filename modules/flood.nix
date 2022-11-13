{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.flood;
in {
  options = {
    services.flood = {
      enable = mkEnableOption (lib.mdDoc "Flood");

      runDir = mkOption {
        type = types.str;
        default = "/var/lib/flood";
      };

      port = mkOption {
        type = types.port;
        default = 3030;
        description = ''
          The port for the Flood web interface
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for the Flood web interface
        '';
      };

      user = mkOption {
        type = types.str;
        default = "flood";
        description = lib.mdDoc "User account under which Flood runs.";
      };

      group = mkOption {
        type = types.str;
        default = "flood";
        description = lib.mdDoc "Group under which Flood runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.flood;
        defaultText = literalExpression "pkgs.flood";
        description = lib.mdDoc ''
          Flood package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      [ "d '${cfg.runDir}' 0700 ${cfg.user} ${cfg.group} - -" ];

    systemd.services.flood = {
      enable = true;
      description = "Flood torrent UI";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.flood}/bin/flood"
          "--port ${toString cfg.port}"
          "--host 0.0.0.0"
          "--rundir ${cfg.runDir}"
        ];
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
    };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    users.users = mkIf (cfg.user == "flood") {
      flood = {
        group = cfg.group;
        home = cfg.runDir;
        uid = config.ids.uids.flood;
      };
    };

    users.groups =
      mkIf (cfg.group == "flood") { flood.gid = config.ids.gids.flood; };
  };
}
