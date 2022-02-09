{ pkgs, config, ... }: {

  home.packages = with pkgs; [
    #office  
    libreoffice
    thunderbird
  ];
}
