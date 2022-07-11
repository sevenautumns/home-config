{ pkgs, config, lib, ... }: {
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      brettm12345.nixfmt-vscode
      streetsidesoftware.code-spell-checker
      matklad.rust-analyzer
      vadimcn.vscode-lldb
      bungcip.better-toml
      #arrterian.nix-env-selector
      #github.copilot
    ];
    userSettings = {
      "rust-analyzer.checkOnSave.command" = "clippy";
      "editor.formatOnSave" = false;
      "editor.tabSize" = 2;
      "debug.allowBreakpointsEverywhere" = true;
    };
  };
}
