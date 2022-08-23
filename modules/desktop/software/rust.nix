{ pkgs, config, lib, inputs, ... }:
{
home.packages = with pkgs;
    [
      cargo-fuzz
      cargo-watch
      trunk
    ];
}
