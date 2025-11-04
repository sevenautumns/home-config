{
  pkgs,
  config,
  lib,
  inputs,
  machine,
  ...
}:
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

  # nixpkgs.config.packageOverrides = super: {
  #   kcc = (pkgs.unstable.kcc.overrideAttrs (old: {
  #     # src = inputs.kcc;
  #     postPatch = ''
  #       substituteInPlace kindlecomicconverter/startup.py \
  #         --replace 'dependencyCheck(' '#dependencyCheck('
  #     '';
  #   }));
  # };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-vaapi
    ];
  };

  home.packages =
    with pkgs;
    lib.optionals (machine.nixos) [
      #office
      libreoffice
      kdePackages.okular

      #com
      thunderbird
      mattermost-desktop
      discord
      discord-canary
      vesktop
      telegram-desktop
      element-desktop

      unstable.lutris
      wine64

      #image
      loupe
      feh
      (inkscape-with-extensions.override {
        inkscapeExtensions = with inkscape-extensions; [ inkstitch ];
      })
      gimp

      freecad
      jabref

      #dev
      nixfmt-rfc-style

      #misc
      arandr
      nvtopPackages.amd

      nautilus
      nemo

      update-kcc.kcc
      calibre

      gamescope

      spotify

      citrix_workspace
    ];

  services.network-manager-applet.enable = !builtins.elem host [ "ft-ssy-avil-w2" ];
  dconf.settings."org/blueman/general" = {
    plugin-list = [ "!ConnectionNotifier" ];
  };
}
