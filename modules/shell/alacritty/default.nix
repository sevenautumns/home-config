{ pkgs, config, ... }: {
  # Alacritty doesnt work yet with homemanager.
  #programs.alacritty = {
  #  enable = true;
  #  settings = {
  #    window = {
  #      padding = {
  #        x = 5;
  #        y = 5;
  #      };
  #      opacity = 0.9;
  #    };
  #  };
  #};
  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
}
