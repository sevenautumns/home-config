{ pkgs, config, inputs, ... }:
let cmus-perl = (pkgs.perl.withPackages (ps: [ ps.HTMLParser ]));

in {

  home.packages = with pkgs; [ cmus cmusfm ];

  # TODO doesnt work yet
  xdg.configFile = {
    "cmus/merge_status_script.sh".source =
      pkgs.writeShellScript "merge_status_script.sh" ''
        ${pkgs.cmusfm}/bin/cmusfm "$@"
        ${cmus-perl}/bin/perl ${inputs.cmus-notify}/cmus-notify.pl "$@"
      '';
    "cmus/notify.cfg".source = ./notify.cfg;
  };
}
