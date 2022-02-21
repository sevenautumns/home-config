{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
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

  outputs = { self, homeManager, my-flakes, nur, deploy-rs, nixpkgs-unstable
    , nixpkgs-stable, ... }@inputs:
    let
      lib = nixpkgs-stable.lib;
      machines = {
        "neesama" = "autumnal";
        "ft-ssy-sfnb" = "frie_sv";
      };
      x86_64 = "x86_64-linux";
    in {
      homeConfigurations = lib.attrsets.mapAttrs' (host: user:
        lib.attrsets.nameValuePair (user + "@" + host)
        (homeManager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            imports = [ ./home.nix ];
            home.packages = [ pkgs.deploy-rs.deploy-rs ];
          };

          pkgs = import nixpkgs-stable {
            system = x86_64;
            overlays = [
              deploy-rs.overlay
              (self: super: {
                unstable =
                  import "${inputs.nixpkgs-unstable}" { system = x86_64; };
                stable = import "${inputs.nixpkgs-stable}" { system = x86_64; };
              })
              nur.overlay
            ];
          };
          extraSpecialArgs = {
            inherit inputs;
            inherit host;
            inherit user;
          };

          system = x86_64;
          homeDirectory = "/home/${user}";
          username = user;
          stateVersion = "21.05";
        })) machines;
    };
}
