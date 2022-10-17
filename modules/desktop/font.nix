{ pkgs, ... }: {
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraMono" "FiraCode" "RobotoMono" "SourceCodePro" ];
    })
    sarasa-gothic
    font-awesome
    unstable.symbola
    roboto
    #siji
    dina-font
    twitter-color-emoji
    comic-mono
    #efont-unicode
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
          <family>Twitter Color Emoji</family>
          <family>FiraCode Nerd Font</family>
          <family>Sarasa UI J</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>sans</family>
        <prefer>
          <family>Roboto</family>
          <family>Twitter Color Emoji</family>
          <family>FiraCode Nerd Font</family>
          <family>Sarasa UI J</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>monospace</family>
        <prefer>
          <family>Dina</family>
          <family>FiraCode Nerd Font Mono</family>
          <family>Twitter Color Emoji</family>
          <family>Sarasa Mono J</family>
        </prefer>
      </alias>
      <selectfont>
        <acceptfont>
          <pattern>
            <patelt name="scalable"><bool>false</bool></patelt>
          </pattern>
        </acceptfont>
      </selectfont>
    </fontconfig>
  '';
}
