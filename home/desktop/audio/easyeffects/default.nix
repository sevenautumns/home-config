{ pkgs, config, host, ... }: {
  services.easyeffects.enable = true;

  xdg.configFile = {
    "easyeffects/output/DT800ProX.json".source = ./DT800ProX.json;
    "easyeffects/output/DT1990Pro.json".source = ./DT1990Pro.json;
    "easyeffects/output/Speaker.json".source = ./Speaker.json;
  };
}
