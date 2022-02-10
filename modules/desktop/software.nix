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
    ] ++ lib.optional (host == "ft") [
      # Element does not work properly 
      element-desktop
    ];
}
