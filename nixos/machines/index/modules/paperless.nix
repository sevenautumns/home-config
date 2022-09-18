{ pkgs, config, inputs, lib, ... }: {
  services.paperless = {
    enable = true;
    user = "autumnal";
    address = "index";
    dataDir = "/media/paperless";
  };
}
