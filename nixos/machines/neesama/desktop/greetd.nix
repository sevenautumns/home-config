{ config, lib, pkgs, modulesPath, ... }: {
  services.xserver = {
    enable = true;
    dpi = 80;
    displayManager.startx.enable = true;
  };

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
            --cmd "startx ~/.xsession"
        '';
      };
    };
  };
}
