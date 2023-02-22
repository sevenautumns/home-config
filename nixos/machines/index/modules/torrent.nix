{ pkgs, config, inputs, lib, ... }: {
  age.secrets = {
    transmission_auth = {
      file = ../../../../secrets/transmission_auth.age;
      path = "/var/lib/transmission/auth";
      owner = "autumnal";
    };
    mullvard_private = {
      file = ../../../../secrets/mullvard_private.age;
      path = "/var/lib/mullvard/private";
    };
  };

  # smart cricket
  secure.transmission = {
    enable = true;
    ips = [ "10.64.141.29/32" ];
    dns = "10.64.0.1";
    namespace = "transmission_wg";
    privateKeyFile = config.age.secrets.mullvard_private.path;
    openRPClocal = true;
    peer = {
      publicKey = "qcvI02LwBnTb7aFrOyZSWvg4kb7zNW9/+rS6alnWyFE=";
      allowedIPs = [ "0.0.0.0/0" ];
      endpoint = "193.32.127.67:443";
    };
  };

  services.transmission = {
    enable = true;
    user = "autumnal";
    group = "transmission";
    credentialsFile = "/var/lib/transmission/auth";
    settings = {
      download-dir = "/media/torrent_storage/completed";
      incomplete-dir = "/media/torrent_storage/incomplete";
      incomplete-dir-enabled = true;
      rpc-authentication-required = true;
      rpc-username = "admin";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
      peer-port = 57342;
      speed-limit-down = 5000;
      speed-limit-down-enabled = true;
      speed-limit-up = 500;
      speed-limit-up-enabled = true;
      alt-speed-down = 5000;
      alt-speed-enabled = false;
      alt-speed-time-begin = 240;
      alt-speed-time-day = 127;
      alt-speed-time-enabled = true;
      alt-speed-time-end = 480;
      alt-speed-up = 1500;
      utp-enabled = false;
    };
  };

  # Limit resource usage for transmission
  systemd.services.transmission = {
    startLimitIntervalSec = 3;
    startLimitBurst = 1;
    serviceConfig = {
      Restart = "on-failure";
      memoryAccounting = true;
      # MemoryHigh = "1000M";
      MemoryMax = "1300M";
    };
  };

  services.flood = {
    enable = true;
    user = "autumnal";
    group = "transmission";
    port = 3030;
    openFirewall = true;
  };
}
