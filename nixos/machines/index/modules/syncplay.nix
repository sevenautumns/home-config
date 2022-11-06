{ pkgs, config, inputs, ... }: {
  services.syncplay = {
    enable = true;
    port = 8999;
    # certDir = "/var/lib/acme/autumnal.de";
    user = "syncplay";
    # group = "nginx";
  };

  assertions = [{
    assertion = pkgs.unstable.syncplay.version == "1.6.9";
    message = "New Version Syncplay. Check if persistent rooms is in nixpkgs";
  }];
  nixpkgs.config.packageOverrides = super: {
    syncplay-nogui = (pkgs.stable.syncplay-nogui.overrideAttrs (old: {
      src = inputs.syncplay;
      version = "unstable-master";
    }));
  };

  systemd.services.syncplay.script = let
    permanent-rooms = pkgs.writeText "permanent-rooms" ''
      anime
    '';
    cmdArgs = [
      "--port"
      config.services.syncplay.port
      "--tls"
      config.services.syncplay.certDir
      "--rooms-db-file"
      "/var/lib/syncplay/rooms-db"
      "--permanent-rooms-file"
      permanent-rooms
    ];
  in pkgs.lib.mkForce ''
    exec ${pkgs.syncplay-nogui}/bin/syncplay-server ${
      pkgs.lib.escapeShellArgs cmdArgs
    }
  '';

  users.users.syncplay = {
    description = "Syncplay server service user";
    home = "/var/lib/syncplay";
    createHome = true;
    homeMode = "750";
    isSystemUser = true;
    group = "users";
  };

  networking.firewall.allowedTCPPorts = [ config.services.syncplay.port ];

  # services.nginx.virtualHosts = {
  #   "autumnal.de" = {
  #     forceSSL = true;
  #     enableACME = true;
  #   };
  # };

  # security.acme = {
  #   certs = {
  #     "autumnal.de" = {
  #       postRun = ''
  #         cp key.pem privkey.pem
  #         systemctl restart syncplay.service
  #       '';
  #     };
  #   };
  # };
}
