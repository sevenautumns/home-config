{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/unbound.ctl";
    settings = {
      # include = [
      #   "\"${config.services.unbound.stateDir}/blacklist.conf\""
      # ];
      server = {
        access-control = [
          "::1/128 allow_snoop"
          "127.0.0.0/8 allow"
          "127.0.0.1/32 allow_snoop"
          "192.168.178.1/24 allow"
          "192.168.250.2/24 allow"
        ];
        interface = [
          "::1"
          "127.0.0.1"
          "192.168.178.2"
          "192.168.250.2"
        ];
        prefer-ip6 = true;
        prefetch = true;
        prefetch-key = true;
        serve-expired = false;
        aggressive-nsec = true;
        hide-identity = true;
        hide-version = true;
        use-caps-for-id = true;
        val-permissive-mode = true;
        # local-data = [
        #   "\"agares.bs.dadada.li. 10800 IN A 192.168.101.1\""
        #   "\"ninurta.bs.dadada.li. 10800 IN A 192.168.101.184\""
        #   "\"agares.bs.dadada.li. 10800 IN AAAA fd42:9c3b:f96d:101::1\""
        #   "\"ninurta.bs.dadada.li. 10800 IN AAAA fd42:9c3b:f96d:101:4a21:bff:fe3e:9cfe\""
        # ];
        # local-zone = [
        #   "\"168.192.in-addr.arpa.\" nodefault"
        #   "\"d.f.ip6.arpa.\" nodefault"
        # ];
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = "yes";
          forward-addr = [
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];
    };
  };

  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "0 4 * * *   root   systemctl restart unbound-blacklist.service"
  #   ];
  # };

  # systemd.services."unbound-blacklist" = {
  #   script = ''
  #     wget -O ${config.services.unbound.stateDir}/blacklist.conf https://small.oisd.nl/unbound
  #   '';
  #   path = with pkgs; [ wget ];
  #   requiredBy = [ "unbound.service" ];
  #   before = [ "unbound.service" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = config.services.unbound.user;
  #     Group = config.services.unbound.group;
  #   };
  # };
}
