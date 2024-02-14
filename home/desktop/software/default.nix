{ pkgs, config, lib, inputs, machine, ... }:
let
  host = machine.host;
  arch = machine.arch;
in
{
  imports = [
    ./alacritty.nix
    ./chromium.nix
    ./firefox.nix
    ./fcitx.nix
    ./kitty.nix
    ./mpv.nix
    ./lutris.nix
    ./rust.nix
    ./screenaudio.nix
    ./vscode.nix
  ];

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
      kcc
      gnome-network-displays
      gthumb
      calibre

      gamescope
      nss
      nss.tools

      libgourou
    ] ++ lib.optionals (machine.nixos) [
      discord
      discord-canary
      tdesktop
      element-desktop
      spotify
    ];

  services.network-manager-applet.enable = !builtins.elem host [ "ft-ssy-avil-w2" ];
  dconf.settings."org/blueman/general" = {
    plugin-list = [ "!ConnectionNotifier" ];
  };
}
