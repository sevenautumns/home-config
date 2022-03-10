{ pkgs, config, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = with pkgs; fixGL vscode;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      streetsidesoftware.code-spell-checker
    ];
  };
}
