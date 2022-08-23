{ pkgs, inputs, config, lib, ... }:
let
  ibus = with pkgs;
    (ibus-with-plugins.override { plugins = [ ibus-engines.mozc ]; });
in {
  i18n.inputMethod.package = ibus;
  home.packages = [ ibus ];
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

  #systemd.user.services."org.freedesktop.IBus.session.GNOME".environment = {
  #  LC_CTYPE = "ja_JP.UTF-8";
  #};
}
