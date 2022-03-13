{ pkgs, ... }: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [ "https://nix-community.cachix.org" ];
    binaryCachePublicKeys =
      [ "autumnal.cachix.org-1:ZeMGbsyGsw3Jv3TzS5fXrWe7tas/GKTmSVnpXNJZQ5w=" ];
  };
}
