{ pkgs, config, lib, ... }:
let inherit (lib.meta) getExe; in {
  programs.command-not-found.enable = false;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      cat = "${getExe pkgs.bat} --paging=never -p";
      fmtnix = "${getExe pkgs.fd} -e nix -X ${getExe pkgs.nixfmt-rfc-style}";
      zf = ''z --pipe="sk --height 40% --layout=reverse"'';
    };
  };
}
