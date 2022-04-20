{ pkgs, ... }: {
  virtualisation.podman.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      #homebridge = {
      #  image = "oznu/homebridge:latest";
      #  volumes = [ "/var/lib/homebridge:/homebridge" ];
      #  environment = {
      #    PGID = "1000";
      #    GUID = "1000";
      #    HOMEBRIDGE_CONFIG_UI = "1";
      #    HOMEBRIDGE_CONFIG_UI_PORT = "8581";
      #    TZ = "Europe/Berlin";
      #  };
      #  extraOptions = [ "--network=host" ];
      #};
    };
  };

  #networking.firewall.allowedTCPPorts = [ 8581 ];

}
