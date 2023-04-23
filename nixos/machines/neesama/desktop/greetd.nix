{ config, lib, pkgs, modulesPath, ... }: {
  services.xserver = {
    enable = true;
    dpi = 80;
    displayManager.startx.enable = true;
  };

  environment.etc.issue.source =
    let os = (builtins.substring 0 5 config.system.nixos.release);
    in pkgs.writeText "issue" (builtins.concatStringsSep "\n" [
      "   /]  German Aerospace"
      "/_Z_Z_7    Center (DLR)"
      "  [/       NixOS ${os} "
      ""
    ]);

  # Creates tuigreet folder for the '--remember' option
  systemd.tmpfiles.rules =
    [ "d '/var/cache/tuigreet' 0700 greeter greeter - -" ];

  # Automatically unlocks login-keyring
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time --remember --asterisks \
            --cmd "Hyprland" \
            --user-menu --issue
        '';
      };
    };
  };
}
