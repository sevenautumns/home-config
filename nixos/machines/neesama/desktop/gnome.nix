{ config, lib, pkgs, modulesPath, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
      #autoLogin.delay = 1;
    };

    displayManager = {
      #defaultSession = "user";
      #autoLogin = {
      #  enable = true;
      #  user = "autumnal";
      #};
      session = [{
        manage = "desktop";
        name = "user";
        start = "exec $HOME/.xsession";
      }];
    };
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

}
