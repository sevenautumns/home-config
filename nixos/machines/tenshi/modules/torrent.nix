{ pkgs, ... }: {
  # https://forum.openwrt.org/t/instruction-config-nordvpn-wireguard-nordlynx-on-openwrt/89976

  # https://discourse.nixos.org/t/setting-up-wireguard-in-a-network-namespace-for-selectively-routing-traffic-through-vpn/10252/8
  # https://mth.st/blog/nixos-wireguard-netns/

  # https://github.com/blazed/cake/blob/cea87117fd6630baa8c10f046f62a66980abc6de/profiles/download_station.nix#L57

  #virtualisation.oci-containers = {
  #  containers = {
  #    transmission = {
  #      image = "ghcr.io/linuxserver/transmission:latest";
  #      user = "1000:1000";
  #      environment = {
  #        WEBUI_PORT = "9091";
  #        PUID = "1000";
  #        PGID = "1000";
  #        TZ = "Europe/Berlin";
  #        TRANSMISSION_WEB_HOME = "/flood-for-transmission/";
  #      };
  #      volumes = [
  #        "/var/lib/transmission/data:/data"
  #        "/var/lib/transmission/config:/config"
  #      ];
  #      extraOptions = [ "--net=container:nordvpn" ];
  #      dependsOn = [ "nordvpn" ];
  #    };
  #    nordvpn = {
  #      ports = [ "9091:9091" ];
  #      image = "ghcr.io/bubuntux/nordlynx:latest";
  #      volumes = [
  #        "/var/lib/nordvpn/data:/etc/wireguard"
  #      ];
  #      environment.NET_LOCAL = "192.145.45.214/32";
  #      environmentFiles = [ "/var/lib/nordvpn/pass" ];
  #      extraOptions = [ "--cap-add=NET_ADMIN" ];
  #    };
  #  };
  #};

  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  systemd.services.wg = {
    description = "wg network interface";
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "netns@wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs;
        writers.writeBash "wg-up" ''
          ${iproute}/bin/ip link add wg0 type wireguard
          ${iproute}/bin/ip link set wg0 netns wg
          ${iproute}/bin/ip -n wg address add 10.5.0.2/32 dev wg0
          ${iproute}/bin/ip netns exec wg \
            ${wireguard}/bin/wg setconf wg0 /var/lib/nordvpn/nordvpn.conf
          ${iproute}/bin/ip -n wg link set wg0 up
          ${iproute}/bin/ip -n wg link set lo up
          ${iproute}/bin/ip -n wg route add default dev wg0
        '';
      ExecStop = with pkgs;
        writers.writeBash "wg-down" ''
          ${iproute}/bin/ip -n wg route del default dev wg0
          ${iproute}/bin/ip -n wg link del wg0
        '';
    };
  };

  services.transmission.enable = true;
  services.transmission.user = "autumnal";
  systemd.services.transmission = {
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "wg.service" ];
    serviceConfig = { NetworkNamespacePath = "/var/run/netns/wg"; };
  };

  systemd.services.transmission-forwarder = {
    enable = true;
    after = [ "transmission.service" ];
    requires = [ "transmission.service" ];
    bindsTo = [ "transmission.service" ];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:9091,fork,reuseaddr,bind=127.0.0.1 exec:'${pkgs.iproute}/bin/ip netns exec wg ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:9091"',nofork
    '';
  };

  services.nginx.virtualHosts = {
    "torrent.autumnal.de" = {
      forceSSL = true;
      enableACME = true;
      basicAuthFile = "/var/lib/transmission/basicauth";
      locations."/".proxyPass = "http://127.0.0.1:9091";
    };
  };
}
