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
    # ./kitty.nix
    ./mpv.nix
    ./rust.nix
    # ./screenaudio.nix
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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-vaapi
    ];
  };

  home.packages = with pkgs;
    lib.optionals (machine.nixos) [
      #office  
      libreoffice
      okular

      #com
      thunderbird
      mattermost-desktop
      discord
      discord-canary
      vesktop
      tdesktop
      element-desktop

      lutris
      # wine64
      breitbandmessung

      #image
      gnome.eog
      inkscape
      gimp

      #dev
      nixfmt-rfc-style

      #misc
      arandr
      nvtopPackages.amd

      # https://github.com/NixOS/nixpkgs/pull/195985
      # gtk4 problem, use stable until fixed
      stable.gnome.nautilus
      cinnamon.nemo

      kcc
      calibre

      gamescope

      spotify
    ];

  services.network-manager-applet.enable = !builtins.elem host [ "ft-ssy-avil-w2" ];
  dconf.settings."org/blueman/general" = {
    plugin-list = [ "!ConnectionNotifier" ];
  };
}
