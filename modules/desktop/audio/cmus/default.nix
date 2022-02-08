{ pkgs, config, ... }:
let cmus-perl = (pkgs.perl.withPackages (ps: [ ps.HTMLParser ]));

in {

  home.packages = with pkgs; [ cmus cmusfm ];

  # TODO doesnt work yet
  xdg.configFile = {
    "cmus/cmus-notify".source = ./cmus-notify;
    "cmus/merge_status_script.sh".text = ''
      #!/usr/bin/env bash

      ${pkgs.cmusfm}/bin/cmusfm "$@"
      ${cmus-perl}/bin/perl ~/.config/cmus/cmus-notify "$@"
    '';
    "cmus/notify.cfg".source = ./notify.cfg;
  };
}
