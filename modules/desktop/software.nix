{ pkgs, config, ... }: {

  home.packages = with pkgs; [
    #office  
    libreoffice
    thunderbird

    #social
    element-desktop

    #media
    mpv

    #dev
    rustup
  ];
}
