{ config, lib, pkgs, modulesPath, ... }: {
  services.xserver = {
    enable = true;
    dpi = 80;
    displayManager.startx.enable = true;
  };

  systemd.tmpfiles.rules = [ "d '/var/cache/tuigreet' 0700 0 0 - -" ];

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
