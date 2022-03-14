{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:guibou/nixGL";
    my-flakes.url = "github:steav005/flakes";
    homeManager = {
      #url = "github:nix-community/home-manager/release-21.11";
      url = "github:Steav005/home-manager/feat/leftwm-module";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    leftwm.url = "github:leftwm/leftwm";
    deploy-rs.url = "github:serokell/deploy-rs";

    polybar-scripts = {
      url = "github:polybar/polybar-scripts";
      flake = false;
    };
    polybar-pulseaudio-control = {
      url = "github:marioortizmanero/polybar-pulseaudio-control";
      flake = false;
    };
    cmus-notify = {
      url = "github:dcx86r/cmus-notify";
      flake = false;
    };
  };

  outputs = { self, homeManager, my-flakes, nur, nixgl, deploy-rs
    , nixpkgs-unstable, nixpkgs-stable, ... }@inputs:
    let
      lib = nixpkgs-stable.lib;
      machines = {
        "neesama" = {
          user = "autumnal";
          arch = "x86_64-linux";
          headless = false;
          non-nixos = {
            nvidia = {
              version = "510.54";
              hash = "sha256-TCDezK4/40et/Q5piaMG+QJP2t+DGtwejmCFVnUzUWE=";
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
        "index" = {
          user = "autumnal";
          address = "192.168.177.2";
          arch = "aarch64-linux";
          headless = true;
          managed-nixos = true;
        };
        "tenshi" = {
          user = "autumnal";
          address = "autumnal.de";
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
            home.packages = [ pkgs.deploy-rs.deploy-rs ];
          };

          pkgs = import nixpkgs-stable {
            system = machine.arch;
            overlays = [
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
            { networking.hostName = host; }
            (./machines + "/${host}.nix")
          ];
          specialArgs = {
            inherit inputs;
            inherit machine;
          };

        }) (lib.filterAttrs (h: m: m.managed-nixos) machines);

      deploy.nodes = lib.mapAttrs (host: machine: {
        hostname = machine.address;
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
    };
}
