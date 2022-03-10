{ pkgs, config, host, ... }: {
  # ft-ssy-sfnb is still on pulseaudio
  services.easyeffects.enable = true;

  xdg.configFile = {
    "easyeffects/output/Headphone.json".source = ./Headphone.json;
    "easyeffects/output/Speaker.json".source = ./Speaker.json;
  };
}
