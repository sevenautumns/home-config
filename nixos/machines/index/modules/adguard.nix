{ pkgs, ... }: {

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      53 # adguardhome dns
    ];
    allowedUDPPorts = [
      53 # adguardhome dns
    ];
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "adguard";
    static_configs = [{ targets = [ "localhost:9617" ]; }];
  }];

  virtualisation.oci-containers = {
    containers = {
      adguard_exporter = {
        image = "ebrianne/adguard-exporter:latest";
        environment = {
          adguard_hostname = "10.4.0.0";
          adguard_username = "admin";
          adguard_port = "3000";
          server_port = "9617";
          interval = "60s";
          adguard_protocol = "http";
        };
        environmentFiles = [ "/var/lib/adguard_exporter/pass" ];
        extraOptions = [ "--cpus=0.5" ];
        ports = [ "9617:9617" ];
      };
    };
  };
}
