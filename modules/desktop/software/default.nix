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
    ./fcitx
    ./redshift.nix
    ./rust.nix
  ];

  services.sxhkd.keybindings = with pkgs; {
    "super + w" = "${fixGL brave}/bin/brave";
    "super + shift + w" = "${fixGL firefox}/bin/firefox";
    "super + shift + Return" =
      "${pkgs.gnome.nautilus}/bin/nautilus --new-window";
  };

  home.packages = with pkgs;
    [
      #office  
      libreoffice
      thunderbird
      mattermost-desktop

      #image
      gnome.eog

      #music
      spotify

      #dev
      nixfmt
      jetbrains.idea-ultimate

      #browser
      (fixGL brave)
      (fixGL firefox)

      #misc
      bitwarden
      arandr
      gnome.nautilus
      feh
      syncplay

      #Social
      (fixGL discord)
      (fixGL discord-canary)
      (fixGL tdesktop)
      (fixAlsa element-desktop)

      #learning
      anki
    ] ++ lib.optionals (host == "ft-ssy-sfnb") [
      # betterlockscreen cant access pem in arch
      betterlockscreen
    ] ++ lib.optionals (machine ? non-nixos) [ (nixGLCommon nixGLNvidia) ];

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  xsession.numlock.enable = true;
  services.sxhkd.enable = true;

  xdg.desktopEntries = {
    screenshot = {
      name = "Screenshot";
      genericName = "Gnome Screenshot Tool";
      # Manually create desktop entry which calls this with --interactive
      exec =
        "${pkgs.gnome.gnome-screenshot}/bin/gnome-screenshot --interactive";
      terminal = false;
      categories = [ "Application" "Graphics" ];
      icon = "org.gnome.Screenshot";
    };
  };

  # Fix Nautilus gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = [ "${pkgs.gnome.gvfs}/lib/gio/modules" ];
  };
}
