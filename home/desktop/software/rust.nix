{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    clang
    clang-tools
    cmake
    gnumake

    rustup
    cargo-fuzz
    cargo-watch
    cargo-outdated
    trunk
  ];
}
