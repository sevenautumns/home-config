{ pkgs, ... }:
let
  efont = pkgs.efont-unicode.overrideAttrs (orig: {
    prePatch = ''
      substituteInPlace f*.bdf --replace 'FAMILY_NAME "Fixed"' 'FAMILY_NAME "EfontFixed"'
      substituteInPlace b*.bdf --replace 'FAMILY_NAME "Biwidth"' 'FAMILY_NAME "EfontBiwidth"'
    '';
  });
in
{
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraMono" "FiraCode" "RobotoMono" "SourceCodePro" ];
    })
    sarasa-gothic
    font-awesome
    unstable.symbola
    roboto
    twitter-color-emoji
    comic-mono
    uw-ttyp0
    monoid
    profont
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
          <family>Ttyp0</family>
          <family>FiraCode Nerd Font Mono</family>
          <family>Twitter Color Emoji</family>
          <family>EfontBiwidth</family>
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
