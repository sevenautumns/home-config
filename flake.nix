{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-main = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niketsu.url = "github:sevenautumns/niketsu";
    # niketsu.url = "github:sevenautumns/niketsu/server/cache";

    # screenaudio = {
    #   url = "git+https://github.com/maltejur/discord-screenaudio?submodules=1";
    #   flake = false;
    # };

    nixd.url = "github:nix-community/nixd";

    # Home manager used repos
    fcitx5-adwaita.url = "github:escape0707/fcitx5-adwaita-dark";
    fcitx5-adwaita.flake = false;

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

  outputs =
    { self
    , home-manager-stable
    , home-manager-main
    , nur
    , deploy-rs
    , nixpkgs
    , nixpkgs-unstable
    , nixpkgs-stable
    , agenix
    , ...
    }@inputs:
    let
      lib = nixpkgs-unstable.lib;
      machines = {
        "vivi" = {
          user = "autumnal";
          arch = "x86_64-linux";
          headless = false;
          nixos = false;
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager-main;
          managed-nixos = false;
        };
        "ft-ssy-sfnb" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = false;
          nixos = true;
          nixpkgs = nixpkgs;
          home-manager = home-manager-stable;
          managed-nixos = false;
        };
        "ft-ssy-avil-w2" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = false;
          nixos = true;
          nixpkgs = nixpkgs;
          home-manager = home-manager-stable;
          managed-nixos = false;
        };
        "ft-ssy-stonks" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = true;
          nixos = true;
          nixpkgs = nixpkgs;
          home-manager = home-manager-stable;
          managed-nixos = false;
        };
        "roxy" = {
          user = "autumnal";
          address = "192.168.178.2";
          arch = "x86_64-linux";
          headless = true;
          nixos = true;
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager-main;
          managed-nixos = true;
        };
        "castle" = {
          user = "autumnal";
          address = "192.168.178.64";
          arch = "aarch64-linux";
          headless = true;
          nixos = true;
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager-main;
          managed-nixos = true;
        };
      };
    in
    {
      homeConfigurations = lib.attrsets.mapAttrs'
        (host: pre_machine:
          let machine = pre_machine // { inherit host; };
          in lib.attrsets.nameValuePair (machine.user + "@" + host)
            (machine.home-manager.lib.homeManagerConfiguration {
              pkgs = import machine.nixpkgs {
                system = machine.arch;
                overlays = [
                  deploy-rs.overlay
                  self.overlays.matryoshka-pkgs
                  nur.overlay
                  inputs.nixd.overlays.default
                ];
              };
              modules = [
                ./home
                {
                  home = {
                    username = machine.user;
                    homeDirectory = "/home/${machine.user}";
                    stateVersion = "23.05";
                    packages = [ agenix.packages."${machine.arch}".agenix ];
                  };
                }
              ];
              extraSpecialArgs = {
                inherit inputs;
                inherit machine;
              };
            }))
        machines;

      nixosConfigurations = lib.mapAttrs
        (host: machine:
          machine.nixpkgs.lib.nixosSystem rec {
            system = machine.arch;
            modules = [
              {
                networking.hostName = host;
                nixpkgs.overlays =
                  [ deploy-rs.overlay self.overlays.matryoshka-pkgs nur.overlay ];
              }
              agenix.nixosModules.default
              self.nixosModules.transmission
              self.nixosModules.flood
              (./nixos/machines + "/${host}")
            ];
            specialArgs = {
              inherit inputs;
              inherit machine;
            };

          })
        (lib.filterAttrs (h: m: m.managed-nixos) machines);

      # Overlay for always having stable and unstable accessible
      overlays.matryoshka-pkgs = final: prev: {
        unstable = import "${inputs.nixpkgs-unstable}" {
          system = prev.system;
          config.allowUnfree = true;
        };
        stable = import "${inputs.nixpkgs-stable}" {
          system = prev.system;
          config.allowUnfree = true;
        };
      };

      nixosModules.transmission = import modules/transmission.nix;
      nixosModules.flood = import modules/flood.nix;

      deploy.nodes = lib.mapAttrs
        (host: machine: {
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
        })
        (lib.filterAttrs (h: m: m ? address) machines);

      # checks = builtins.mapAttrs
      #   (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
