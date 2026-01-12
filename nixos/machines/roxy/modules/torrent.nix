{
  pkgs,
  config,
  inputs,
  lib,
  flakeRoot,
  ...
}:
{
  age.secrets = {
    transmission_auth = {
      file = flakeRoot + "/secrets/transmission_auth.age";
      path = "/var/lib/transmission/auth";
      owner = "autumnal";
    };
    mullvad_coyote = {
      file = flakeRoot + "/secrets/mullvad_coyote.age";
      path = "/var/lib/mullvad/coyote";
    };
  };

  # coyote
  secure.transmission = {
    enable = true;
    ips = [ "10.69.2.101/32" ];
    dns = "10.64.0.1";
    namespace = "transmission_wg";
    privateKeyFile = config.age.secrets.mullvad_coyote.path;
    openRPClocal = true;
    peer = {
      publicKey = "wDjbvO94t0UI1RlimpEFFv7kJ6DngthvuRX6uBN0wAA=";
      endpoint = "193.32.127.84:51820";
    };
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    user = "autumnal";
    group = "media";
    credentialsFile = "/var/lib/transmission/auth";
    settings = {
      umask = 2;
      download-dir = "/media/torrent_storage/completed";
      incomplete-dir = "/media/torrent_storage/incomplete";
      incomplete-dir-enabled = true;
      rpc-authentication-required = true;
      rpc-username = "admin";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
      # peer-port = 57342;
      speed-limit-down = 2000;
      speed-limit-down-enabled = true;
      speed-limit-up = 100;
      speed-limit-up-enabled = true;
      # alt-speed-down = 5000;
      # alt-speed-enabled = false;
      # alt-speed-time-begin = 240;
      # alt-speed-time-day = 127;
      # alt-speed-time-enabled = true;
      # alt-speed-time-end = 480;
      # alt-speed-up = 1500;
      utp-enabled = false;
      ratio-limit-enabled = false;
      # ratio-limit = 2;
    };
  };

  # # Limit resource usage for transmission
  # systemd.services.transmission = {
  #   startLimitIntervalSec = 3;
  #   startLimitBurst = 1;
  #   serviceConfig = {
  #     Restart = "on-failure";
  #     memoryAccounting = true;
  #     # MemoryHigh = "1000M";
  #     MemoryMax = "1300M";
  #   };
  # };

  services.flood = {
    enable = true;
    host = "0.0.0.0";
    # user = "autumnal";
    # group = "media";
    port = 3030;
    openFirewall = true;
  };
}
