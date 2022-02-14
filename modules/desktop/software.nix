{ pkgs, config, host, lib, inputs, ... }: {

  home.packages = with pkgs;
    [
      #office  
      libreoffice
      thunderbird

      #dev
      nixfmt
      rustup
      pkg-config
      pkgconfig
      openssl
      openssl.dev
      jetbrains.idea-ultimate

      #dev dependencies
      cairo
      pango
      gtk3
      gtk3-x11
      glib

      #misc
      bitwarden
      neofetch
    ] ++ lib.optionals (host == "ft-ssy-sfnb") [
      # Element does not work properly 
      element-desktop
    ];
}
