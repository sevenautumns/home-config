{ pkgs, ... }:
let
  mplus-bitmap = with pkgs;
    stdenv.mkDerivation rec {
      pname = "mplus-bitmap";
      version = "2.2.4";

      src = fetchzip {
        # http://jikasei.me/font/jf-dotfont/
        # https://packages.debian.org/buster/fonts/xfonts-jisx0213
        url =
          "https://web.archive.org/web/20221124094022if_/https://ftp.halifax.rwth-aachen.de/osdn/mplus-fonts/5030/mplus_bitmap_fonts-2.2.4.tar.gz";
        sha256 = "sha256-AtXoVb/HoI8FdsgMwLyearg7kN8HTJ0SjqH5xyZ+SBY=";
      };
      # srcs = [
      #   (fetchurl {
      #     url = "https://web.archive.org/web/20140915160202if_/http://www12.ocn.ne.jp/~imamura/jiskan16-2004-1.bdf.gz";
      #     sha256 = "sha256-bxBxW2OzgHqYap27f5rV5mBeiYEbG1oFy1pjlte1rnw=";
      #   })
      #   (fetchurl {
      #     url = "https://web.archive.org/web/20140915160204if_/http://www12.ocn.ne.jp/~imamura/K14-2004-1.bdf.gz";
      #     sha256 = "sha256-q3tSykttJLjxrI7BLStgDdlCSRpyvFEtn79ZZFHn3kU=";
      #   })
      #   (fetchurl {
      #     url = "https://web.archive.org/web/20140915160215if_/http://www12.ocn.ne.jp/~imamura/K12-1.bdf.gz";
      #     sha256 = "sha256-Dq7yl4UTT6poYH3fC1oVsw+02qOIz8M3bx7asH+UMEM=";
      #   })
      #   (fetchurl {
      #     url = "https://web.archive.org/web/20140915160216if_/http://www12.ocn.ne.jp/~imamura/K12-2.bdf.gz";
      #     sha256 = "sha256-aSOdUwlPtoc2ULOBHIfBoVnecauUC3t2nOqfdZG+Bdc=";
      #   })
      # ];
      
      # dontUnpack = true;
      # unpackPhase = ''
      #   ls -lha
      #   tar -xvf $src
      # '';

      nativeBuildInputs = [ perl libfaketime xorg.fonttosfnt xorg.mkfontscale ];

      # prePatch = ''
      #   # for i in $(grep -Rl "FAMILY_NAME \"Fixed\""); do
      #   for i in $srcs; do
      #     cp "$i" "./$(stripHash "''${i%.gz}")" 
      #   done
      #   ls -lha
      #   substituteInPlace *.bdf \
      #     --replace 'FAMILY_NAME "Fixed"' \
      #               'FAMILY_NAME "Ttyp0"'
      #   # done
      # '';

      # dontConfigure = true;
      # preConfigure = ''
      #   cat << EOF > VARIANTS.dat
      #   COPYTO AccStress PApostropheAscii
      #   COPYTO PAmComma AccGraveAscii
      #   COPYTO Digit0Slashed Digit0
      #   EOF
      # '';
      
      buildPhase = ''
        runHook preBuild
      
        fontDir="$(pwd)/build"
        mkdir $fontDir
        DESTDIR=$fontDir MKBOLD=NO ./install_mplus_fonts
        cp fonts_e/*.bdf build/
        cp fonts_j/*.bdf build/
        
        for f in $fontDir/*.bdf; do
            local file_name="''${f%.bdf}" 
            faketime -f "1970-01-01 00:00:01" \
            fonttosfnt -v -o "$file_name.otb" "$f"
        done

        runHook postBuild
      '';
      
      installPhase = ''
        runHook preInstall

        fontDir="share/fonts/misc"
        # cd $fontDir
        # ls -lha
        # install -m 644 -D -t "$out/$fontDir" build/*.pcf.gz 
        install -m 644 -D -t "$out/$fontDir" build/*.otb
        # install -m 644 -D -t "$bdf/$fontDir" build/*.bdf
        mkfontdir "$bdf/$fontDir"
        mkfontdir "$out/$fontDir"

        runHook postInstall
      '';

      # outputs = [ "out" "bdf" ];

      # postBuild = ''
      #   # convert bdf fonts to psf
      #   build=$(pwd)
      #   mkdir {psf,otb}
      #   cd ${bdf2psf}/share/bdf2psf
      #   for i in $build/bdf/*.bdf; do
      #     name="$(basename $i .bdf)"
      #     bdf2psf \
      #       --fb "$i" standard.equivalents \
      #       ascii.set+useful.set+linux.set 512 \
      #       "$build/psf/$name.psf"
      #   done
      #   cd -
      #   # convert unicode bdf fonts to otb
      #   for i in $build/bdf/*.bdf; do
      #     name="$(basename $i .bdf)"
      #     fonttosfnt -v -o "$build/otb/$name.otb" "$i"
      #   done
      # '';

      # postInstall = ''
      # '';
      # installPhase = ''
      #   make
      #   make install
      #   make install-bdf

      #   fontDir="$out/share/fonts/X11/japanese"
        
      #   # convert bdf fonts to psf
      #   build=$(pwd)
      #   mkdir {psf,otb}
      #   cd ${bdf2psf}/share/bdf2psf
      #   for i in $fontDir/*.bdf; do
      #     name="$(basename $i .bdf)"
      #     bdf2psf \
      #       --fb "$i" standard.equivalents \
      #       ascii.set+useful.set+linux.set 512 \
      #       "$build/psf/$name.psf"
      #   done
      #   cd -
      #   # convert unicode bdf fonts to otb
      #   for i in $fontDir/*.bdf; do
      #     name="$(basename $i .bdf)"
      #     fonttosfnt -v -o "$build/otb/$name.otb" "$i"
      #   done
        
      #   # install psf fonts
      #   fontDir="$out/share/consolefonts"
      #   install -m 644 -D psf/*.psf -t "$fontDir"

      #   # install otb fonts
      #   fontDir="$out/share/fonts/X11/japanese"
      #   install -m 644 -D otb/*.otb -t "$fontDir"
      #   mkfontdir "$fontDir"
      # '';

      # configurePhase = ''
      #   runHook preConfigure
      #   ./configure \
      #     --with-fontdir=$out/share/fonts/X11/japanese \
      #     --with-pcf \
      #     --enable-compress=gzip \
      #     --disable-latin1
      #   runHook postConfigure
      # '';
    };

in {
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraMono" "FiraCode" "RobotoMono" "SourceCodePro" ];
    })
    sarasa-gothic
    font-awesome
    unstable.symbola
    roboto
    #siji
    # dina-font
    twitter-color-emoji
    comic-mono
    uw-ttyp0
    # mplus-outline-fonts.osdnRelease
    # mplus-bitmap
    # cozette
    # jisx0213
    efont-unicode
    mplus-outline-fonts.githubRelease
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
          <family>Fixed</family>
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
