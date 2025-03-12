{ pkgs, config, ... }:
{
  services.redshift = {
    enable = true;
    latitude = 51.8;
    longitude = 10.3;
  };
}
