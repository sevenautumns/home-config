{ pkgs, inputs, ... }: {

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.wireguard.interfaces.wg0 = {
    ips = [ "192.168.15.1/24" ];
    listenPort = 51666;
    privateKeyFile = "/var/lib/wireguard/private";
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -o eth0 -j MASQUERADE
    '';
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.15.0/24 -o eth0 -j MASQUERADE
    '';
    peers = [
      {
        # Autumnal iPhone
        allowedIPs = [ "192.168.15.2/32" ];
        publicKey = "bmhYCGLFVv0xdjztteX2sb7qmRfuj2lT+LoAqJ1KPj0=";
      }
      {
        # Castle iPad
        allowedIPs = [ "192.168.15.3/32" ];
        publicKey = "PDXbI76JckuYg3pfnWYfFiQu7xpTklBrTXZpLpQ0vUo=";
      }
      {
        # Castle iPhone
        allowedIPs = [ "192.168.15.4/32" ];
        publicKey = "1rdsudDpFs6Fc8XQcyrw0d26lCrS6aiahBLARInn210=";
      }
    ];
  };

  age.secrets = {
    wireguard-private = {
      file = ../../../../secrets/wireguard-castle.age;
      path = "/var/lib/wireguard/private";
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      51666 # Wireguard Listenport
    ];
  };
}
