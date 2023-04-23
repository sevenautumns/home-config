{ pkgs, inputs, ... }: {
  services.plex = {
    enable = true;
    user = "autumnal";
    package = pkgs.stable-05.plex;
    extraScanners = with inputs; [ absolut-series-scanner ];
    extraPlugins = with inputs; [
      services-bundle
      myanimelist-bundle
      hama-bundle
    ];
  };
}
