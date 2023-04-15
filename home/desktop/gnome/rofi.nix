{ pkgs, config, lib, inputs, ... }:
let theme = config.theme;
in {
  #services.sxhkd.keybindings = {
  #  #"super + d" = "rofi -no-lazy-grab -show drun -modi drun";
  #  #"super + t" = "rofi -show window -modi window";
  #  #"XF86Calculator" = "rofi -show calc -mode calc";
  #};

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" =
      {
        binding = "<Super>p";
        command = "rofi-pass";
        name = "Rofi Pass";
      };
  };

  programs.rofi = {
    enable = true;
    #font = "FiraCode Nerd Font 11";
    font = "Noto Sans Regular 11";
    extraConfig = {
      icon-theme = "Yaru";
      sorting-method = "fzf";
      matching = "fuzzy";
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
      drun-display-format = "{name}";
      show-icons = true;
      modi = "drun,window,run,ssh";
    };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background = mkLiteral "#303030FB";
        background-alt = mkLiteral "#00000000";
        background-bar = mkLiteral "#444444FF";
        foreground = mkLiteral "#f2f2f2EE";
        accent = mkLiteral "#3DAEE966";
      };
      "window" = {
        transparency = "real";
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0px";
        border-color = mkLiteral "@border";
        border-radius = mkLiteral "12px";
        width = mkLiteral "40%";
        location = mkLiteral "center";
        x-offset = 0;
        y-offset = 0;
      };
      "prompt" = {
        enabled = true;
        padding = mkLiteral "0.30% 1% 0% -0.5%";
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        font = "FantasqueSansMono Nerd Font 12";
      };

      "entry" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        placeholder-color = mkLiteral "@foreground";
        expand = true;
        font = "Noto Sans Bold 11";
        horizontal-align = 0;
        placeholder = "Search";
        padding = mkLiteral "0.10% 0% 0% 0%";
        blink = true;
      };

      "inputbar" = {
        children = [ (mkLiteral "prompt") (mkLiteral "entry") ];
        background-color = mkLiteral "@background-bar";
        text-color = mkLiteral "@foreground";
        expand = false;
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@accent";
        margin = mkLiteral "0% 0% 0% 0%";
        padding = mkLiteral "1.5%";
      };

      "listview" = {
        background-color = mkLiteral "@background-alt";
        columns = 1;
        #columns = 5;
        lines = 10;
        #lines = 4;
        spacing = mkLiteral "0%";
        fixed-height = false;
        fixed-columns = true;
        cycle = false;
        dynamic = true;
        layout = mkLiteral "vertical";
      };

      "mainbox" = {
        background-color = mkLiteral "@background-alt";
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "0% 0% 0% 0%";
        border-color = mkLiteral "@accent";
        children = [ (mkLiteral "inputbar") (mkLiteral "listview") ];
        spacing = mkLiteral "2%";
        padding = mkLiteral "2% 1% 2% 1%";
      };

      "element" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "horizontal";
        #orientation = mkLiteral "vertical";
        border-radius = mkLiteral "0%";
        padding = mkLiteral "1% 1% 1% 1%";
        #padding = mkLiteral "2% 0% 2% 0%";
      };

      "element-icon" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        horizontal-align = mkLiteral "0.5";
        vertical-align = mkLiteral "0.5";
        size = mkLiteral "30px";
        #size = mkLiteral "64px";
        border = mkLiteral "0px";
      };

      "element-text" = {
        background-color = mkLiteral "@background-alt";
        text-color = mkLiteral "inherit";
        expand = true;
        #horizontal-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0";
        vertical-align = mkLiteral "0.5";
        margin = mkLiteral "0.5% 0.5% 0.5% 0.5%";
        #margin = mkLiteral "0.5% 0.5% -0.5% 0.5%";
      };

      "element selected" = {
        background-color = mkLiteral "@background-bar";
        text-color = mkLiteral "@foreground";
        border = mkLiteral "0% 0% 0% 0%";
        border-radius = mkLiteral "12px";
        border-color = mkLiteral "@accent";
      };
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
