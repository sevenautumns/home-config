{ pkgs, config, host, lib, inputs, ... }: {

  home.packages = with pkgs;
    [
      #office  
      libreoffice
      thunderbird

      #image
      gnome.eog

      #dev
      nixfmt
      rustup
      jetbrains.idea-ultimate

      #misc
      bitwarden
      neofetch
      arandr
    ] ++ lib.optionals (host == "ft-ssy-sfnb") [
      # Element does not work properly 
      element-desktop
      # betterlockscreen cant access pem in arch
      betterlockscreen
    ];
}
