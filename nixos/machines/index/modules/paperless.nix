{ pkgs, config, inputs, lib, ... }: {
  services.paperless = {
    enable = false;
    user = "autumnal";
    package = pkgs.stable.paperless-ngx;
    address = "10.4.0.0";
    dataDir = "/media/paperless";
  };
}
