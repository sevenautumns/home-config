{ pkgs, config, machine, lib, inputs, ... }: {
  services.redshift = {
    enable = true;
    # Germany
    latitude = 51.8;
    longitude = 10.3;
    # Japan
    # latitude = 35.6;
    # longitude = 139.8;
    settings.redshift.transition = 0;
  };
}
