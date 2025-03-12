{ pkgs, ... }:
let

in
{
  services.kea.dhcp4.enable = true;
  services.kea.dhcp4.settings = {
    interfaces-config = {
      interfaces = [
        "eth0"
      ];
      service-sockets-max-retries = -1;
    };
    lease-database = {
      name = "/var/lib/kea/dhcp4.leases";
      persist = true;
      type = "memfile";
    };
    rebind-timer = 2000;
    renew-timer = 1000;
    subnet4 = [
      # Local IP Pool
      {
        pools = [
          {
            pool = "192.168.1.50 - 192.168.1.240";
          }
        ];
        subnet = "192.168.1.0/24";
        option-data = [
          {
            name = "routers";
            data = "192.168.1.2";
          }
          {
            name = "domain-name-servers";
            data = "1.1.1.1";
          }
        ];
      }
      # Freifunk IP Pool
      # {
      #   pools = [
      #     {
      #       pool = "192.0.0.50 - 192.0.255.250";
      #     }
      #   ];
      #   subnet = "192.0.0.0/16";
      # }
    ];
    valid-lifetime = 86400;
  };
  services.kea.dhcp6.enable = true;
  services.kea.dhcp6.settings = {
    interfaces-config = {
      interfaces = [
        "eth0"
      ];
      service-sockets-max-retries = -1;
    };
    lease-database = {
      name = "/var/lib/kea/dhcp6.leases";
      persist = true;
      type = "memfile";
    };
    rebind-timer = 2000;
    renew-timer = 1000;
    subnet6 = [
      # Local IP Pool
      {
        pools = [
          {
            pool = "fd00::50 - fd00::fff0";
          }
        ];
        subnet = "fd00::/112";
        # option-data = [
        #   {
        #     name = "routers";
        #     data = "fd00::2";
        #   }
        #   {
        #     name = "domain-name-servers";
        #     data = "2606:4700:4700::1111";
        #   }
        # ];
      }
      # Freifunk IP Pool
      # {
      #   pools = [
      #     {
      #       pool = "192.0.0.50 - 192.0.255.250";
      #     }
      #   ];
      #   subnet = "192.0.0.0/16";
      # }
    ];
    valid-lifetime = 86400;
  };
}
