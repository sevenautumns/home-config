{ pkgs, inputs, ... }: {

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
}
