{ pkgs, config, lib, inputs, ... }: {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    settings = {
      asciify_paths = false;
      import = { languages = [ "en" "jp" ]; };
      plugins = [ "spotify" ];
      musicbrainz.enabled = false;
      spotify.source_weight = 0.0;
    };
  };
}
