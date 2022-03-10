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
          system = "x86_64-linux";
          patch-opengl = {
            version = "510.54";
            hash = "sha256-TCDezK4/40et/Q5piaMG+QJP2t+DGtwejmCFVnUzUWE=";
          };
        };
        "ft-ssy-sfnb" = {
          user = "frie_sv";
          system = "x86_64-linux";
          patch-opengl = null;
        };
      };
    in {
      homeConfigurations = lib.attrsets.mapAttrs' (host: machine:
        lib.attrsets.nameValuePair (machine.user + "@" + host)
        (homeManager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            imports = [ ./home.nix ];
            home.packages = [ pkgs.deploy-rs.deploy-rs ];
          };

          pkgs = import nixpkgs-stable {
            system = machine.system;
            overlays = [
              deploy-rs.overlay
              (self: super: {
                unstable = import "${inputs.nixpkgs-unstable}" {
                  system = machine.system;
                };
                stable = import "${inputs.nixpkgs-stable}" {
                  system = machine.system;
                };
              })
              nur.overlay
              (import ./nixgl-overlay.nix machine nixgl)
            ];
          };
          extraSpecialArgs = let user = machine.user;
          in {
            inherit inputs;
            inherit host;
            inherit user;
          };

          system = machine.system;
          homeDirectory = "/home/${machine.user}";
          username = machine.user;
          stateVersion = "21.05";
        })) machines;
    };
}
