{ pkgs, ... }:
let
  mplus-bitmap = with pkgs;
    stdenv.mkDerivation rec {
      pname = "mplus-bitmap";
      version = "2.2.4";

      src = fetchzip {
        url =
          "https://web.archive.org/web/20221124094022if_/https://ftp.halifax.rwth-aachen.de/osdn/mplus-fonts/5030/mplus_bitmap_fonts-2.2.4.tar.gz";
        sha256 = "sha256-AtXoVb/HoI8FdsgMwLyearg7kN8HTJ0SjqH5xyZ+SBY=";
      };

      nativeBuildInputs = [
        perl
        libfaketime
        bdf2psf
        xorg.xset
        xorg.bdftopcf
        xorg.fonttosfnt
        xorg.mkfontscale
      ];

      postPatch = ''
        patchShebangs install_mplus_fonts
      '';

      buildPhase = ''
          runHook preBuild
          
          DESTDIR=. ./install_mplus_fonts
        	rm fonts_j/mplus_j1*b.bdf

          build=$(pwd)
          # mkdir {psf,otb}
          # cd ${bdf2psf}/share/bdf2psf
          # for f in $build/fonts_e/*.bdf; do
          #   name="$(basename $f .bdf)"
          #   bdf2psf \
          #     --fb "$f" standard.equivalents \
          #     ascii.set+useful.set+linux.set 512 \
          #     "$build/fonts_e/$name.psf"
          # done
          # for f in $build/fonts_j/*.bdf; do
          #   name="$(basename $f .bdf)"
          #   bdf2psf \
          #     --fb "$f" standard.equivalents \
          #     ascii.set+useful.set+linux.set 512 \
          #     "$build/fonts_j/$name.psf"
          # done
          # cd -

          for f in $build/fonts_e/*.bdf; do
            name="$(basename $f .bdf)"
            fonttosfnt -v -o "$build/fonts_e/$name.otb" "$f"
          done
          for f in $build/fonts_j/*.bdf; do
            name="$(basename $f .bdf)"
            fonttosfnt -v -m 2 -o "$build/fonts_j/$name.otb" "$f"
          done

          runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        # install psf fonts
        # fontDir="$out/share/consolefonts"
        # install -m 644 -D fonts_{e,j}/*.psf -t "$fontDir"

        # # install otb fonts
        find 
        fontDir="$out/share/fonts/misc"
        # fontDirE="$fontDir/fonts_e"
        fontDirJ="$fontDir/fonts_j"
        # install -m 644 -D fonts_e/*.{otb,pcf.gz,bdf} -t "$fontDirE"
        # install -m 644 -D fonts_e/fonts.alias -t "$fontDirE"
        # install -m 644 -D fonts_j/*{otb,pcf.gz,bdf} -t "$fontDirJ"
        # install -m 644 -D fonts_j/fonts.alias -t "$fontDirJ"
        install -m 644 -D fonts_j/*.{otb,bdf,pcf.gz} -t "$fontDirJ"
        # install -m 644 -D fonts_j/fonts.alias -t "$fontDirJ"
        # mkfontdir "$fontDirE"
        mkfontdir "$fontDirJ"

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
    #siji
    # dina-font
    twitter-color-emoji
    comic-mono
    uw-ttyp0
    monoid
    victor-mono
    # mplus-outline-fonts.osdnRelease
    # mplus-bitmap
    # cozette
    # jisx0213
    efont-unicode
    # mplus-outline-fonts.githubRelease
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
          <family>VictorMono</family>
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
