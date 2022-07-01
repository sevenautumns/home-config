{ pkgs, inputs, config, lib, ... }: {
  i18n.inputMethod.package = with pkgs;
    (ibus-with-plugins.override { plugins = [ ibus-engines.mozc ]; });
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };
}
