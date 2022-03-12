{ lib, ... }:
with lib;
let
  nvidia = types.submodule {
    options = {
      version = mkOption {
        default = null;
        type = types.str;
      };
      hash = mkOption {
        default = null;
        type = types.str;
      };
    };
  };
  non-nix = types.submodule {
    options = {
      nvidia = mkOption {
        default = null;
        type = nvidia;
      };
      pipewire = mkOption {
        default = true;
        type = types.bool;
      };
    };
  };
  machine = types.submodule {
    options = {
      user = mkOption {
        default = null;
        type = types.str;
      };
      host = mkOption {
        default = null;
        type = types.str;
      };
      arch = mkOption {
        default = null;
        type = types.str;
      };
      headless = mkOption {
        default = false;
        type = types.bool;
      };
      non-nix = mkOption {
        default = null;
        type = types.nullOr non-nix;
      };
    };
  };
in {
  options = {
    machine = mkOption {
      type = machine;
      default = null;
    };
  };
}
