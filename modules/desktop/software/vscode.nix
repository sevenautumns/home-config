{ pkgs, config, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = with pkgs; fixGL vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      streetsidesoftware.code-spell-checker
      matklad.rust-analyzer
      #arrterian.nix-env-selector
      #github.copilot
    ];
    userSettings = {
      "rust-analyzer.checkOnSave.command" = "clippy";
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
    };
  };
}
