{ pkgs, config, lib, inputs, machine, ... }:
let
  host = machine.host;
  #naersk = pkgs.callPackage inputs.naersk {};
  #rdf = naersk.buildPackage inputs.rdf;
in {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./ibus.nix
    ./kitty.nix
    ./mpv.nix
    #./redshift.nix
    ./rust.nix
    ./vscode.nix
  ];

  #services.sxhkd.keybindings = with pkgs; {
  #  "super + w" = "firefox";
  #  "super + shift + w" = "brave";
  #  "super + shift + Return" =
  #    "${pkgs.gnome.nautilus}/bin/nautilus --new-window";
  #};

  nixpkgs.config.packageOverrides = super: {
    syncplay = (pkgs.stable.syncplay.overrideAttrs (old: {
      src = inputs.syncplay;
      version = "unstable-master";
    }));
    kcc = (pkgs.stable.kcc.overrideAttrs (old: {
      src = inputs.kcc;
      postPatch = ''
        substituteInPlace kindlecomicconverter/startup.py \
          --replace 'dependencyCheck(' '#dependencyCheck('
      '';
    }));
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
      gnome-feeds
      deploy-rs.deploy-rs
      kcc
      gnome-network-displays
      calibre
      
      heroic
      lutris

      #learning
      anki
    ] ++ lib.optionals (machine.nixos) [
      discord
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
  # services.sxhkd.enable = true;

  #services.syncthing.enable = true;
  #services.syncthing.tray.enable = true;

  # Fix Nautilus gvfs
  home.sessionVariables = {
    GIO_EXTRA_MODULES = [ "${pkgs.gnome.gvfs}/lib/gio/modules" ];
  };
}
