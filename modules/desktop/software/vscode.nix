{ pkgs, config, lib, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      streetsidesoftware.code-spell-checker
    ];
  };
}
