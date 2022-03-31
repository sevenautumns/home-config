{ pkgs, inputs, ... }: {
  services.plex = {
    enable = true;
    user = "autumnal";
    extraScanners = with inputs; [ absolut-series-scanner ];
    extraPlugins = with inputs; [
      services-bundle
      myanimelist-bundle
      hama-bundle
    ];
  };
}
