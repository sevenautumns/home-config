/*
*  Taken from https://github.com/Zumorica/GradientOS/blob/7fd124e1c966205a761937d13ec053b353f427c5/mixins/steamcmd.nix
*/
{ config, pkgs, lib, ... }:
let inherit (lib.meta) getExe getExe'; in
{
  users.users.steamcmd = {
    isSystemUser = true;
    group = config.users.groups.steamcmd.name;
    home = "/var/lib/steamcmd";
    homeMode = "777";
    createHome = true;
  };

  users.groups.steamcmd = { };

  systemd.services."steamcmd@" = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    unitConfig = {
      StopWhenUnneeded = true;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.resholve.writeScript "steam" {
        interpreter = "${getExe pkgs.zsh}";
        inputs = with pkgs; [
          patchelf
          steamcmd
        ];
        execer = [
          "cannot:${getExe pkgs.steamcmd "steamcmd"}"
        ];
      } ''
        set -eux

        instance=''${1:?Instance Missing}
        eval 'args=(''${(@s:_:)instance})'
        app=''${args[1]:?App ID missing}
        beta=''${args[2]:-}
        betapass=''${args[3]:-}

        dir=/var/lib/steamcmd/apps/$instance

        cmds=(
          +force_install_dir $dir
          +login anonymous
          +app_update $app validate
        )

        if [[ $beta ]]; then
          cmds+=(-beta $beta)
          if [[ $betapass ]]; then
            cmds+=(-betapassword $betapass)
          fi
        fi

        cmds+=(+quit)

        steamcmd $cmds

        for f in $dir/*; do
          if ! [[ -f $f && -x $f ]]; then
            continue
          fi

          # Update the interpreter to the path on NixOS.
          patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $f || true
        done
      ''} %i";
      PrivateTmp = true;
      Restart = "on-failure";
      StateDirectory = "steamcmd/apps/%i";
      TimeoutStartSec = 3600; # Allow time for updates.
      User = config.users.users.steamcmd.name;
      WorkingDirectory = "~";
    };
  };

  # Some games might depend on the Steamworks SDK redistributable, so download it.
  systemd.services.steamworks-sdk = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "steamcmd@1007.service" "steamworks-sdk.timer" ];
    after = [ "steamcmd@1007.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.escapeShellArgs [
        "${getExe' pkgs.coreutils "echo"}"
        "Done! Steamworks SDK should be downloaded now."
      ];
      Restart = "no";
      User = config.users.users.steamcmd.name;
      WorkingDirectory = "~";
    };
  };

  systemd.timers.steamworks-sdk = {
    description = "Updates Steamworks SDK daily.";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "steamworks-sdk.service";
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
  };
}
