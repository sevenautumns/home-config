{ config, pkgs, lib, ... }: {
  imports = [ modules/desktop modules/shell ];

  #home.username = "autumnal";
  #home.homeDirectory = "/home/autumnal";
  #home.stateVersion = "22.05";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = [ pkgs.xterm pkgs.nixfmt pkgs.bitwarden pkgs.neofetch
  #inputs.my-flakes.packages."x86_64-linux".fcitx5-nord
   ];

  # basic config

  xdg.configFile = {
    #"easyeffects/output".source =
    #  config.lib.file.mkOutOfStoreSymlink "${configDir}/easyeffects/output";

    #"cmus/cmus-notify".source = ./config/cmus/cmus-notify;
    #"cmus/merge_status_script.sh".source = ./config/cmus/merge_status_script.sh;
    #"cmus/notify.cfg".source = ./config/cmus/notify.cfg;

    #"dunst/dunstrc".source = ./config/dunst/dunstrc;

    #"gtk-3.0/bookmarks".source =
    #  config.lib.file.mkOutOfStoreSymlink "${configDir}/gtk-3.0/bookmarks";

    # i3 config
    #"polybar".source =
    #  config.lib.file.mkOutOfStoreSymlink "${configDir}polybar";
    #"gtk-3.0/settings.ini".source =
    #  config.lib.file.mkOutOfStoreSymlink "${configDir}gtk-3.0/settings.ini";
  };

}
