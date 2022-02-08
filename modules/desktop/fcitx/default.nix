{ pkgs, inputs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  home.file.".local/share/fcitx5/themes/".source =
    inputs.my-flakes.packages."x86_64-linux".fcitx5-nord;

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
