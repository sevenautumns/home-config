{ pkgs, inputs, config, ... }: {
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
      text = ''
        # Vertical Candidate List
        Vertical Candidate List=False
        # Use Per Screen DPI
        PerScreenDPI=True
        # Use mouse wheel to go to prev or next page
        WheelForPaging=True
        # Font
        Font="Sarasa Mono J ${
          builtins.toString config.programs.alacritty.settings.font.size
        }"
        # Menu Font
        MenuFont="Sarasa Mono J ${
          builtins.toString config.programs.alacritty.settings.font.size
        }"
        # Use input method langauge to display text
        UseInputMethodLangaugeToDisplayText=True
        # Theme
        Theme=Nord-Dark
      '';
    };
    "fcitx5/profile" = {
      force = true;
      source = ./profile;
    };
  };
}
