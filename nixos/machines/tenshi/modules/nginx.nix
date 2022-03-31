{ pkgs, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = "friedrich122112@googlemail.com";
  };
}
