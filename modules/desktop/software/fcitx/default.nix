{ pkgs, inputs, config, ... }:
let
  default-keyboard = config.home.keyboard.layout
    + (if config.home.keyboard.variant == "us" then "-us" else "");
in {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-lua
      libsForQt5.fcitx5-qt
      fcitx5-gtk
    ];
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
      text = ''
        [Groups/0]
        # Group Name
        Name=Default
        # Layout
        Default Layout=${default-keyboard}
        # Default Input Method
        DefaultIM=mozc

        [Groups/0/Items/0]
        # Name
        Name=keyboard-${default-keyboard}
        # Layout
        Layout=

        [Groups/0/Items/1]
        # Name
        Name=mozc
        # Layout
        Layout=

        [GroupOrder]
        0=Default
      '';
    };
  };
}
