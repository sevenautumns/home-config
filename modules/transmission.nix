{ config, pkgs, lib, ... }:
with lib;
let cfg = config.secure.transmission;
in {
  options = {
    secure.transmission = {
      enable = mkEnableOption "tunneled transmission";
      aggressive = mkOption {
        default = true;
        type = types.bool;
      };
      openRPClocal = mkOption { type = types.bool; };
      dns = mkOption { type = types.str; };
      ips = mkOption { type = with types; listOf str; };
      privateKeyFile = mkOption { type = types.str; };
      namespace = mkOption { type = types.str; };
      interfaceName = mkOption {
        type = types.str;
        default = "wgt";
      };
      peer = {
        publicKey = mkOption { type = types.str; };
        allowedIPs = mkOption { type = with types; listOf str; };
        endpoint = mkOption { type = types.str; };
        keepalive = mkOption {
          type = types.int;
          default = 25;
        };
      };
    };
  };

  config = mkMerge [
    (mkIf config.services.transmission.enable {
      assertions = [
        {
          # This is for guaranteeing that the transmission service still exists and the name didn"t change
          assertion = cfg.enable;
          message = "Transmission is enabled but not `secure.transmission`!";
        }
      ];
    })
    (mkIf cfg.enable {
      # Some assertions for assuring tunneling
      assertions = [
        {
          # This is for guaranteeing that we are using the wireguard namespace with the transmission service
          assertion =
            config.systemd.services.transmission.serviceConfig.NetworkNamespacePath
            == "/var/run/netns/${cfg.namespace}";
          message = "Transmission Network namespace changed!";
        }
        {
          # This is for guaranteeing that the transmission service still exists and the name didn"t change
          assertion = config.systemd.services.transmission.enable;
          message = ''
            Transmission service not enabled!
            Please verify Wireguard usage
          '';
        }
      ];

      # Resolve Config for namespace
      environment.etc."netns/${cfg.namespace}/resolv.conf" = {
        text = "nameserver ${cfg.dns}";
        mode = "0664";
      };

      # Network Interface Setup
      networking.wireguard.interfaces.${cfg.interfaceName} = {
        # Before starting the interface, delete and recreate namespace
        preSetup = ''
          set -x
          ip netns del ${cfg.namespace} || true
          ip netns add ${cfg.namespace}
          ip -n ${cfg.namespace} link set dev lo up
        '';
        # When stopping the interface, delete the namespace
        postShutdown = ''
          ip netns del ${cfg.namespace} || true
        '';
        # Attach the wireguard interface to the created namespace
        interfaceNamespace = cfg.namespace;
        # Use provided information for Wireguard configuration
        ips = cfg.ips;
        privateKeyFile = cfg.privateKeyFile;
        peers = [{
          publicKey = cfg.peer.publicKey;
          allowedIPs = cfg.peer.allowedIPs;
          endpoint = cfg.peer.endpoint;
          persistentKeepalive = cfg.peer.keepalive;
        }];
      };

      systemd.services = mkMerge [
        {
          transmission = {
            bindsTo = [ "wireguard-${cfg.interfaceName}.service" ];
            requires = [ "network-online.target" ];
            after = [ "wireguard-${cfg.interfaceName}.service" ];
            # Make transmission run in network namespace
            serviceConfig.NetworkNamespacePath =
              "/var/run/netns/${cfg.namespace}";
            # Re-add network namespace resolv.conf for transmission
            # Because Transmission overrides /etc and would use the original
            # /etc/resolv.conf otherwise
            serviceConfig.BindReadOnlyPaths =
              [ "/etc/netns/${cfg.namespace}/resolv.conf:/etc/resolv.conf" ];
          };
        }
        (mkIf cfg.openRPClocal {
          # Optional forward RPC port to 127.0.0.1 of the machine
          transmission-forwarder = {
            enable = true;
            bindsTo = [ "transmission.service" ];
            wantedBy = [ "multi-user.target" ];
            script = let
              port = toString config.services.transmission.settings.rpc-port;
            in ''
              ${pkgs.socat}/bin/socat tcp-listen:${port},fork,reuseaddr,bind=0.0.0.0 exec:'${pkgs.iproute2}/bin/ip netns exec ${cfg.namespace} ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:${port}"',nofork
            '';
          };

        })
      ];
    })
  ];
}
