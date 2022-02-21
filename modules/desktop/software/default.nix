{ pkgs, config, host, lib, inputs, ... }: {
  imports = [
    ./mpv.nix
    ./vscode.nix
    ./alacritty.nix
    ./fcitx
    ./redshift.nix
    ./autorandr.nix
  ];

  services.sxhkd.keybindings = {
    "super + w" = "${pkgs.brave}/bin/brave";
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
      rustup
      jetbrains.idea-ultimate

      #misc
      bitwarden
      neofetch
      arandr
      brave
      gnome.nautilus

      #learning
      anki
    ] ++ lib.optionals (host == "ft-ssy-sfnb") [
      # Element does not work properly 
      element-desktop
      # betterlockscreen cant access pem in arch
      betterlockscreen
    ];
}
