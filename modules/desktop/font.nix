{ pkgs, ... }: {
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraMono" "FiraCode" "RobotoMono" "SourceCodePro" ];
    })
    roboto
    sarasa-gothic
    font-awesome
    symbola
    siji
  ];

  #fonts
  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <alias binding="strong">
        <family>sans-serif</family>
        <prefer>
          <family>Roboto</family>
          <family>Siji</family>
          <family>Sarasa UI J</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>sans</family>
        <prefer>
          <family>Roboto</family>
          <family>Siji</family>
          <family>Sarasa UI J</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>monospace</family>
        <prefer>
          <family>FiraCode Nerd Font Mono</family>
          <family>Siji</family>
          <family>Sarasa Mono J</family>
          <family>Symbola</family>
        </prefer>
      </alias>
    </fontconfig>
  '';
}
