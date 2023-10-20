{ pkgs, config, lib, inputs, machine, ... }:
let
  host = machine.host;
  arch = machine.arch;
  #naersk = pkgs.callPackage inputs.naersk {};
  #rdf = naersk.buildPackage inputs.rdf;
  # hm-options = pkgs.writeShellScriptBin "hm-options" ''
  #   xdg-open ${
  #     inputs.homeManager.packages.${machine.arch}.docs-html
  #   }/share/doc/home-manager/options.html $@
  # '';
in {
  imports = [
    ./alacritty.nix
    ./beets.nix
    ./chromium.nix
    ./firefox.nix
    ./fcitx.nix
    # ./ibus.nix
    ./warpd.nix
    ./kitty.nix
    ./mpv.nix
    ./lutris.nix
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
    kcc = (pkgs.stable.kcc.overrideAttrs (old: {
      # src = inputs.kcc;
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

      #misc
      arandr
      monero-cli
      nvtop-amd

      # https://github.com/NixOS/nixpkgs/pull/195985
      # gtk4 problem, use stable until fixed
      stable.gnome.nautilus

      feh
      gnome-feeds
      deploy-rs.deploy-rs
      kcc
      gnome-network-displays
      gthumb
      # hm-options
      calibre

      gamescope
      nss
      nss.tools

      libgourou

      hakuneko
      (makeDesktopItem {
        name = "hakuneko-desktop-no-sandbox";
        desktopName = "HakuNeko Desktop No-Sandbox";
        exec = "hakuneko --no-sandbox";
        type = "Application";
        icon = "hakuneko-desktop";
      })
    ] ++ lib.optionals (machine.nixos) [
      discord
      discord-canary
      webcord
      tdesktop
      element-desktop
      spotify
      brave
    ] ++ lib.optionals (host == "neesama") [
      # inputs.knock.packages.x86_64-linux.knock
    ];

  # xsession.numlock.enable = true;
  services.network-manager-applet.enable = true;
  # services.blueman-applet.enable = true;
  dconf.settings."org/blueman/general" = {
    plugin-list = [ "!ConnectionNotifier" ];
  };

  # services.sxhkd.enable = true;

  #services.syncthing.enable = true;
  #services.syncthing.tray.enable = true;
}
