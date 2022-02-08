{ pkgs, config, ... }: {
  xdg.configFile = {
    "cmus/cmus-notify".source = ./cmus-notify;
    "cmus/merge_status_script.sh".source = ./merge_status_script.sh;
    "cmus/notify.cfg".source = ./notify.cfg;
  };
}
