{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  #TODO fcitx5 nord theme 

  xdg.configFile = {
    "fcitx5/config" = {
      force = true;
      source = ./config;
    };
    "fcitx5/conf/classicui.conf" = {
      force = true;
      source = ./classicui.conf;
    };
    "fcitx5/profile" = {
      force = true;
      source = ./profile;
    };
  };
}
