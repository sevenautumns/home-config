{ pkgs, config, inputs, lib, ... }: {
  services.paperless = {
    enable = false;
    user = "autumnal";
    address = "10.4.0.0";
    dataDir = "/media/paperless";
  };
}
