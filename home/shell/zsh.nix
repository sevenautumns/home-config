{ pkgs, config, ... }: {
  programs.command-not-found.enable = false;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --paging=never -p";
      fmtnix = "${pkgs.fd}/bin/fd -e nix -X ${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      zf = ''z --pipe="sk --height 40% --layout=reverse"'';
    };
  };
}
