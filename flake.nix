{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-pop-launcher.url = "github:samhug/nixpkgs/pop-launcher";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix.url = "github:ryantm/agenix";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.utils.follows = "flake-utils";
    };
    deploy-rs.url = "github:serokell/deploy-rs";

    gobot.url = "github:c0nvulsiv3/gobot";
    gobot.flake = false;

    knock.url = "github:BentonEdmondson/knock";
    kcc.url = "github:ciromattia/kcc";
    kcc.flake = false;

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Home manager used repos
    cmus-notify.url = "github:dcx86r/cmus-notify";
    cmus-notify.flake = false;
    fcitx5-adwaita.url = "github:escape0707/fcitx5-adwaita-dark";
    fcitx5-adwaita.flake = false;

    pop-shell.url = "github:pop-os/shell/master_jammy";
    pop-shell.flake = false;
    pop-launcher.url = "github:pop-os/launcher";
    pop-launcher.flake = false;
    syncplay.url = "github:Syncplay/syncplay";
    syncplay.flake = false;

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

  outputs = { self, homeManager, nur, nixgl, deploy-rs, nixpkgs-unstable
    , nixpkgs-stable, nixpkgs-master, agenix, ... }@inputs:
    let
      lib = nixpkgs-unstable.lib;
      machines = {
        "neesama" = {
          user = "autumnal";
          arch = "x86_64-linux";
          headless = false;
          nixos = true;
          managed-nixos = true;
        };
        "ft-ssy-sfnb" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = false;
          nixos = true;
          managed-nixos = false;
        };
        "ft-ssy-stonks" = {
          user = "frie_sv";
          arch = "x86_64-linux";
          headless = true;
          nixos = true;
          managed-nixos = false;
        };
        "index" = {
          user = "autumnal";
          #address = "10.4.0.0";
          address = "192.168.178.2";
          arch = "aarch64-linux";
          headless = true;
          nixos = true;
          managed-nixos = true;
        };
        "tenshi" = {
          user = "autumnal";
          address = "10.3.0.0";
          arch = "x86_64-linux";
          headless = true;
          nixos = true;
          managed-nixos = true;
        };
        "castle" = {
          user = "autumnal";
          #address = "10.2.0.0";
          address = "192.168.2.250";
          arch = "aarch64-linux";
          headless = true;
          nixos = true;
          managed-nixos = true;
        };
      };
    in {
      homeConfigurations = lib.attrsets.mapAttrs' (host: pre_machine:
        let machine = pre_machine // { inherit host; };
        in lib.attrsets.nameValuePair (machine.user + "@" + host)
        (homeManager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable {
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
                pop-launcher = import "${inputs.nixpkgs-pop-launcher}" {
                  system = machine.arch;
                  config.allowUnfree = true;
                };
                master = import "${inputs.nixpkgs-master}" {
                  system = machine.arch;
                  config.allowUnfree = true;
                };
              })
              nur.overlay
            ];
          };
          modules = [
            ./home.nix
            {
              home = {
                username = machine.user;
                homeDirectory = "/home/${machine.user}";
                stateVersion = "21.05";
                packages = [ agenix.packages."${machine.arch}".agenix ];
              };
            }
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit machine;
          };
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
