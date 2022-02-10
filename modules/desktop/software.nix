{ pkgs, config, host, lib, ... }: {

  home.packages = with pkgs;
    [
      #office  
      libreoffice
      thunderbird

      #media
      mpv

      #dev
      rustup
      nixfmt

      #misc
      bitwarden
      neofetch
    ] ++ lib.optionals (host == "ft-ssy-sfnb") [
      # Element does not work properly 
      element-desktop
      # Nautilus neither
      gnome.nautilus
    ];
}
