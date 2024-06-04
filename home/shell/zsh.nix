{ pkgs, config, lib, ... }:
let inherit (lib.meta) getExe; in {
  programs.command-not-found.enable = false;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      cat = "${getExe pkgs.bat} --paging=never -p";
      fmtnix = "${getExe pkgs.fd} -e nix -X ${getExe pkgs.nixfmt}";
      zf = ''z --pipe="sk --height 40% --layout=reverse"'';
    };
  };
}
