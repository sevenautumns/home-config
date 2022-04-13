{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:guibou/nixGL";
    my-flakes.url = "github:steav005/flakes";
    agenix.url = "github:ryantm/agenix";
    homeManager = {
      url = "github:nix-community/home-manager";
      #url = "github:Steav005/home-manager/feat/leftwm-module";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    leftwm.url = "github:leftwm/leftwm";
    deploy-rs.url = "github:serokell/deploy-rs";
    mach-nix.url = "github:DavHau/mach-nix";

    # Home manager used repos
    polybar-scripts.url = "github:polybar/polybar-scripts";
    polybar-scripts.flake = false;
    polybar-pulseaudio-control.url =
      "github:marioortizmanero/polybar-pulseaudio-control";
    polybar-pulseaudio-control.flake = false;
    cmus-notify.url = "github:dcx86r/cmus-notify";
    cmus-notify.flake = false;
    mpv-discord.url = "github:tnychn/mpv-discord";
    mpv-discord.flake = false;
    #rdf.url = "github:mfs/rust-df";
    #rdf.flake = false;
    #naersk.url = "github:nix-community/naersk";

    #Prometheus Exporter
    adguard-exporter.url = "github:ebrianne/adguard-exporter";
    adguard-exporter.flake = false;
    transmission-exporter.url = "github:metalmatze/transmission-exporter";
    transmission-exporter.flake = false;

    #Plex
    services-bundle.url = "github:pierre1313/Services.bundle";
    services-bundle.flake = false;
    myanimelist-bundle.url = "github:Fribb/MyAnimeList.bundle";
    myanimelist-bundle.flake = false;
    hama-bundle.url = "github:ZeroQI/Hama.bundle";
    hama-bundle.flake = false;
    absolut-series-scanner.url = "github:ZeroQI/Absolute-Series-Scanner";
    absolut-series-scanner.flake = false;
  };

  outputs = { self, homeManager, my-flakes, nur, nixgl, deploy-rs
    , nixpkgs-unstable, nixpkgs-stable, agenix, ... }@inputs:
    let
      lib = nixpkgs-unstable.lib;
      machines = {
        "neesama" = {
          user = "autumnal";
          arch = "x86_64-linux";
          headless = false;
          non-nixos = {
            nvidia = {
              version = "510.60.02";
              hash = "sha256-qADfwFSQeP2Mbo5ngO+47uh4cuYFXH9fOGpHaM4H4AM=";
            };
          };
          managed-nixos = false;
        };
        "ft-ssy-sfnb" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = false;
          managed-nixos = false;
        };
        "ft-ssy-stonks" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = true;
          managed-nixos = false;
        };
        "index" = {
          user = "autumnal";
          address = "10.4.0.0";
          arch = "aarch64-linux";
          headless = true;
          managed-nixos = true;
        };
        "tenshi" = {
          user = "autumnal";
          address = "10.3.0.0";
          arch = "x86_64-linux";
          headless = true;
          managed-nixos = true;
        };
      };
    in {
      homeConfigurations = lib.attrsets.mapAttrs' (host: pre_machine:
        let machine = pre_machine // { inherit host; };
        in lib.attrsets.nameValuePair (machine.user + "@" + host)
        (homeManager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }: {
            imports = [ ./home.nix ];
            home.packages = [
              pkgs.deploy-rs.deploy-rs
              agenix.packages."${machine.arch}".agenix
            ];
          };

          pkgs = import nixpkgs-unstable {
            system = machine.arch;
            overlays = [
              deploy-rs.overlay
              (self: super:
                let
                  unstable = import "${inputs.nixpkgs-unstable}" {
                    system = machine.arch;
                    config.allowUnfree = true;
                  };
                  stable = import "${inputs.nixpkgs-stable}" {
                    system = machine.arch;
                    config.allowUnfree = true;
                  };
                in { inherit unstable stable; })
              nur.overlay
              (import ./overlay/nixgl-overlay.nix machine nixgl)
              (import ./overlay/alsa-overlay.nix machine)
            ];
          };
          extraSpecialArgs = {
            inherit inputs;
            inherit machine;
          };

          system = machine.arch;
          homeDirectory = "/home/${machine.user}";
          username = machine.user;
          stateVersion = "21.05";
        })) machines;

      nixosConfigurations = lib.mapAttrs (host: machine:
        lib.nixosSystem rec {
          system = machine.arch;
          modules = [
            {
              nixpkgs.overlays = [
                deploy-rs.overlay
                (self: super: {
                  unstable = import "${inputs.nixpkgs-unstable}" {
                    system = machine.arch;
                    config.allowUnfree = true;
                  };
                  stable = import "${inputs.nixpkgs-stable}" {
                    system = machine.arch;
                    config.allowUnfree = true;
                  };
                })
                nur.overlay
              ];
            }
            agenix.nixosModule
            { networking.hostName = host; }
            (./nixos/machines + "/${host}")
          ];
          specialArgs = {
            inherit inputs;
            inherit machine;
          };

        }) (lib.filterAttrs (h: m: m.managed-nixos) machines);

      deploy.nodes = lib.mapAttrs (host: machine: {
        hostname = machine.address;
        profilesOrder = [ "system" "user" ];
        fastConnection = false;
        profiles = {
          user = {
            sshUser = machine.user;
            path = deploy-rs.lib.${machine.arch}.activate.home-manager
              self.homeConfigurations."${machine.user}@${host}";
          };
        } // lib.attrsets.optionalAttrs (machine.managed-nixos) {
          system = {
            sshUser = "admin";
            path = deploy-rs.lib.${machine.arch}.activate.nixos
              self.nixosConfigurations."${host}";
            user = "root";
          };
        };
      }) (lib.filterAttrs (h: m: m ? address) machines);

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
