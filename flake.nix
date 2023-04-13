{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.utils.follows = "flake-utils";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # gobot.url = "github:c0nvulsiv3/gobot";
    # gobot.flake = false;

    herbstluftwm.url = "github:herbstluftwm/herbstluftwm";
    herbstluftwm.flake = false;

    herbst3 = {
      url = "github:sevenautumns/herbst3";
      inputs.herbstluftwm.follows = "herbstluftwm";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.utils.follows = "flake-utils";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nil = {
    #   url = "github:oxalica/nil";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # Home manager used repos
    cmus-notify.url = "github:dcx86r/cmus-notify";
    cmus-notify.flake = false;
    fcitx5-adwaita.url = "github:escape0707/fcitx5-adwaita-dark";
    fcitx5-adwaita.flake = false;

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

  outputs = { self, home-manager, nur, deploy-rs, nixpkgs-unstable
    , nixpkgs-stable, agenix, ... }@inputs:
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
        # "tenshi" = {
        #   user = "autumnal";
        #   address = "10.3.0.0";
        #   arch = "x86_64-linux";
        #   headless = true;
        #   nixos = true;
        #   managed-nixos = true;
        # };
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
        (home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable {
            system = machine.arch;
            overlays =
              [ deploy-rs.overlay self.overlays.matryoshka-pkgs nur.overlay ];
          };
          modules = [
            ./home
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

        }) (lib.filterAttrs (h: m: m.managed-nixos) machines);

      # https://github.com/LEXUGE/flake nixosModule example
      # nixosModules.test = let pkgs = nixpkgs-stable; in (import ./modules/desktop/audio {inherit pkgs lib home-manager; });

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
      # nixosModules.gobot = let gobot = inputs.gobot;
      # in import modules/gobot.nix;
      # nixosModules.lavalink = import modules/lavalink.nix;
      # nixosModules.syncplay = import modules/syncplay.nix;
      nixosModules.flood = import modules/flood.nix;

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
