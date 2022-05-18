{ pkgs, inputs, ... }:
#let
#  adguard-exporter = pkgs.buildGoModule {
#    name = "adguard-exporter";
#    src = inputs.adguard-exporter;
#    vendorSha256 = "sha256-/KLllxdk5hQSuRXkOUZkSgLDSdscwIGtR8QoS8Pgc5U=";
#  };
#in 
{

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

  #services.prometheus.scrapeConfigs = [{
  #  job_name = "adguard";
  #  static_configs = [{ targets = [ "localhost:9617" ]; }];
  #}];

  #age.secrets.adguard = {
  #  file = ../../../../secrets/adguard.age;
  #  path = "/var/lib/adguard_exporter/adminpass";
  #};

  #systemd.services.adguard-exporter = {
  #  enable = true;
  #  bindsTo = [ "adguardhome.service" ];
  #  wantedBy = [ "multi-user.target" ];
  #  script = ''
  #    adguard_hostname=localhost \
  #    adguard_username=admin \
  #    adguard_port=3000 \
  #    server_port=9617 \
  #    interval=60s \
  #    adguard_protocol=http \
  #    adguard_password=$(cat /var/lib/adguard_exporter/adminpass) \
  #    ${adguard-exporter}/bin/adguard-exporter
  #  '';
  #};
}
