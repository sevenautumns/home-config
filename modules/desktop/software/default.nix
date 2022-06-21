{ pkgs, config, lib, inputs, machine, ... }:
let
  host = machine.host;
  #naersk = pkgs.callPackage inputs.naersk {};
  #rdf = naersk.buildPackage inputs.rdf;
in {
  imports = [
    ./mpv.nix
    ./vscode.nix
    ./alacritty.nix
    ./firefox.nix
    ./kitty.nix
    ./fcitx.nix
    #./redshift.nix
    ./rust.nix
  ];

  services.sxhkd.keybindings = with pkgs; {
    "super + w" = "firefox";
    "super + shift + w" = "brave";
    "super + shift + Return" =
      "${pkgs.gnome.nautilus}/bin/nautilus --new-window";
  };

  home.packages = with pkgs;
    [
      #office  
      libreoffice
      thunderbird
      mattermost-desktop
      okular

      #image
      gnome.eog
      inkscape
      gimp

      #dev
      nixfmt
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional

      #misc
      bitwarden
      arandr
      gnome.nautilus
      feh
      syncplay

      #learning
      anki
    ] ++ lib.optionals (machine.nixos) [
      discord-canary
      tdesktop
      element-desktop
      spotify
      brave
    ] ++ lib.optionals (host == "neesama")
    [ inputs.knock.packages.x86_64-linux.knock ];

  services.network-manager-applet.enable = false;
  services.blueman-applet.enable = false;
  xsession.numlock.enable = true;
  services.sxhkd.enable = true;

  services.syncthing.enable = true;
  #services.syncthing.tray.enable = true;

  # Fix Nautilus gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = [ "${pkgs.gnome.gvfs}/lib/gio/modules" ];
  };
}
