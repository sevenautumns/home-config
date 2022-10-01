{ pkgs, config, lib, inputs, ... }:
let theme = config.theme;
in {
  programs.rofi = with config.theme; {
    enable = true;
    # font = "FiraCode Nerd Font Medium 12";
    font = "Dina Medium 10";
    # font = "Noto Sans Regular 11";
    # plugins = [ pkgs.rofi-calc ];
    extraConfig = {
      sort = true;
      sorting-method = "fzf";
      matching = "fuzzy";
      icon-theme = "Yaru";
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      drun-display-format = "{name}";
      show-icons = true;
      modi = "drun,window,run,ssh";
    };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        # font = "FiraCode Nerd Font Medium 10";
        font = "Dina Medium 10";
        bg0 = mkLiteral gray0;
        bg1 = mkLiteral gray3;
        fg0 = mkLiteral white;

        pad = mkLiteral "6px";
        spac = mkLiteral "4px";

        accent-color = mkLiteral brown;
        urgent-color = mkLiteral red;

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        magin = 0;
        padding = 0;
        spacing = 0;
      };
      "window" = {
        location = mkLiteral "center";
        width = mkLiteral "40%";
        y-offset = 0;

        # width = 480;
        # y-offset = -160;

        border = mkLiteral "2px";
        border-color = mkLiteral "@accent-color";
        background-color = mkLiteral "@bg0";
      };
      "inputbar" = {
        spacing = mkLiteral "@spac";
        padding = mkLiteral "@pad";

        text-color = mkLiteral "@accent-color";
        background-color = mkLiteral "@bg1";
      };

      "prompt, entry, element-icon, element-text" = {
        vertical-align = mkLiteral "0.5";
      };

      "prompt" = { text-color = mkLiteral "@accent-color"; };

      "textbox" = {
        padding = mkLiteral "@pad";
        text-color = mkLiteral "@accent-color";
        background-color = mkLiteral "@bg1";
      };

      "listview" = {
        padding = mkLiteral "4px 0";
        lines = 16;
        colums = 1;

        fixed-height = false;
      };

      "element" = {
        padding = mkLiteral "@pad";
        spacing = mkLiteral "@spac";
      };

      "element normal normal" = { text-color = mkLiteral "@fg0"; };

      "element normal urgent" = { text-color = mkLiteral "@urgent-color"; };

      "element normal active" = { text-color = mkLiteral "@accent-color"; };

      "element selected" = { text-color = mkLiteral "@bg0"; };

      "element selected normal, element selected active" = {
        background-color = mkLiteral "@accent-color";
      };

      "element selected urgent" = {
        background-color = mkLiteral "@urgent-color";
      };

      "element-icon" = { size = mkLiteral "0.8em"; };

      "element-text" = { text-color = mkLiteral "inherit"; };
    };
    pass = {
      enable = true;
      extraConfig = ''
        # https://github.com/carnager/rofi-pass/issues/223
        help_color="#FF0000"

        USERNAME_field='login'
      '';
    };
  };
}
