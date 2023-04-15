{ config, lib, pkgs, modulesPath, ... }: {
  services.xserver = {
    enable = true;
    dpi = 80;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };

    displayManager = {
      defaultSession = "user";
      job.preStart = "sleep 4";
      autoLogin = {
        enable = false;
        user = "autumnal";
      };
      session = [{
        manage = "desktop";
        name = "user";
        start = "exec $HOME/.xsession";
      }];
    };
    desktopManager.gnome.enable = true;
  };
}
