{ pkgs, config, ... }: {
  programs.command-not-found.enable = false;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --paging=never -p";
      fmtnix = "${pkgs.fd}/bin/fd -e nix -X ${pkgs.nixfmt}/bin/nixfmt";
      zf = ''z --pipe="sk --height 40% --layout=reverse"'';
    };
  };
}
