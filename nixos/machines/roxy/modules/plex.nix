{ pkgs, inputs, ... }:
{
  services.plex = {
    enable = true;
    user = "autumnal";
    group = "media";
    # package = pkgs.stable-05.plex;
    extraScanners = with inputs; [ absolut-series-scanner ];
    extraPlugins = with inputs; [
      services-bundle
      myanimelist-bundle
      hama-bundle
    ];
  };

  services.jellyfin = {
    enable = true;
    group = "media";
  };

  users.groups.media.members = [ "autumnal" ];
}
