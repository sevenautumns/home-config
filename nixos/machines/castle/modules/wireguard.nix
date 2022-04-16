{ pkgs, inputs, ... }: {

  #networking.wireguard.interfaces.wg0 = {
  #  ips = [ "192.168.2./24" ];
  #  privateKey = "..secret..";
  #  listenPort = 51666;
  #  peers = [{
  #    allowedIPs = [ "0.0.0.0/0" ];
  #    publicKey = "CiEyx82EHuibAc4AvB+BRbTVh9p1mDNIhBQ64mWUMA8=";
  #  }];
  #};

  networking.firewall = {
    allowedUDPPorts = [
      51666 # Wireguard Listenport
    ];
  };
}
