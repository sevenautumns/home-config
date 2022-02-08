{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    my-flakes.url = "github:steav005/flakes";
    homeManager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, homeManager, my-flakes, nur, deploy-rs
    , nixpkgs-unstable, nixpkgs-stable, ... }@inputs: {
      homeConfigurations = {
        "autumnal@neesama" = homeManager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            imports = [ ./home.nix ];
            home.packages = [ pkgs.deploy-rs.deploy-rs ];
          };

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              deploy-rs.overlay
              (self: super: {
                unstable = import "${inputs.nixpkgs-unstable}" {
                  system = "x86_64-linux";
                };
                stable = import "${inputs.nixpkgs-stable}" {
                  system = "x86_64-linux";
                };
              })
              nur.overlay
            ];
          };
          extraSpecialArgs = { inherit inputs; };

          system = "x86_64-linux";
          homeDirectory = "/home/autumnal";
          username = "autumnal";
          stateVersion = "21.05";
        };
      };
    };
}
