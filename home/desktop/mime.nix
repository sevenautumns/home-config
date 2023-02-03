{ pkgs, config, lib, ... }: {
  # Configure xdg
  xdg = {

    # Enable managing of xdg directories
    enable = true;

    # Support XDG Shared MIME-info specification
    mime.enable = true;

    # Allow files to be opened with appropriate programs
    mimeApps = {
      enable = true;

      associations.added = config.xdg.mimeApps.defaultApplications;

      # Configure default applications for mimetypes
      defaultApplications = {

        # Applications
        "application/pdf" = [ "firefox.desktop" ];
        "application/zip" = [ "org.gnome.Nautilus.desktop" ];
        "application/octet-stream" =
          [ "org.gnome.Nautilus.desktop" "firefox.desktop" ];
        "application/x-compressed-tar" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-xz-compressed-tar" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        # "application/json" = ["neovide.desktop"];

        # Scheme
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/chrome" = [ "firefox.desktop" ];

        # Directories
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

        # Text
        "text/html" = [ "firefox.desktop" "helix.desktop" ];
        "text/markdown" = [ "helix.desktop" ];
        "text/plain" = [ "helix.desktop" ];
        "text/x-log" = [ "helix.desktop" ];

        # Images
        "image/png" = [ "feh.desktop" "firefox.desktop" ];
        "image/jpg" = [ "feh.desktop" "firefox.desktop" ];
        "image/gif" = [ "feh.desktop" "firefox.desktop" ];

        # Email
        "x-scheme-handler/mailto" = [ "firefox.desktop" ];
      };
      # associations.removed = {
      #   "application/pdf" = "wine-extension-pdf.desktop";
      #   "application/rtf" = "wine-extension-rtf.desktop";
      #   "application/vnd.ms-htmlhelp" = "wine-extension-chm.desktop";
      #   "application/winhlp" = "wine-extension-hlp.desktop";
      #   "application/x-extension-htm" = "wine-extension-htm.desktop";
      #   "application/x-extension-html" = "wine-extension-html.desktop";
      #   "application/x-mswinurl" = "wine-extension-url.desktop";
      #   "application/x-mswrite" = "wine-extension-wri.desktop";
      #   "application/x-wine-extension-ini" = "wine-extension-ini.desktop";
      #   "application/x-wine-extension-msp" = "wine-extension-msp.desktop";
      #   "application/xml" = "wine-extension-xml.desktop";
      #   "image/gif" = "wine-extension-gif.desktop";
      #   "image/jpeg" =
      #     [ "wine-extension-jfif.desktop" "wine-extension-jpe.desktop" ];
      #   "image/png" = "wine-extension-png.desktop";
      #   "text/plain" = "wine-extension-txt.desktop";
      #   "text/vbscript" = "wine-extension-vbs.desktop";
      # };
    };

    # Configure system directories
    systemDirs = {

      # Directory names to add to XDG_CONFIG_DIRS
      config = [ ];

      # Directory names to add to XDG_DATA_DIRS
      data = [ ];
    };

    # Configure user directories
    userDirs = {

      # Enable management of user directories
      enable = true;
      createDirectories = true;

      # Set directories
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";

      # Configure additional directories
      extraConfig = { XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots"; };
    };
  };

  # Overwrite all wine desktop files, because wine thinks its so great at opening everything
  home.file = builtins.listToAttrs (map (d: {
    name = ".local/share/applications/${d}";
    value = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=placeholder
      '';
      force = true;
    };
  }) [
    "wine-extension-chm.desktop"
    "wine-extension-gif.desktop"
    "wine-extension-hlp.desktop"
    "wine-extension-htm.desktop"
    "wine-extension-ini.desktop"
    "wine-extension-jfif.desktop"
    "wine-extension-jpe.desktop"
    "wine-extension-msp.desktop"
    "wine-extension-pdf.desktop"
    "wine-extension-png.desktop"
    "wine-extension-rtf.desktop"
    "wine-extension-txt.desktop"
    "wine-extension-url.desktop"
    "wine-extension-vbs.desktop"
    "wine-extension-wri.desktop"
    "wine-extension-xml.desktop"
    "wine-extension-html.desktop"
  ]);
}
