{
  pkgs,
  config,
  lib,
  machine,
  inputs,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  programs.vscode = {
    enable = true;
    package = with pkgs; if machine.nixos then vscodium else hello;
    extensions =
      with pkgs.vscode-extensions;
      with pkgs.vscode-utils;
      [
        bbenoist.nix
        streetsidesoftware.code-spell-checker
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
        bungcip.better-toml
        james-yu.latex-workshop
        mkhl.direnv
        oderwat.indent-rainbow
        jnoortheen.nix-ide
      ];
    keybindings = [
      {
        "key" = "ctrl+shift+c";
        "command" = "editor.action.clipboardCopyAction";
      }
      {
        "key" = "ctrl+shift+v";
        "command" = "editor.action.clipboardPasteAction";
      }
      {
        "key" = "ctrl+tab";
        "command" = "workbench.action.showAllEditors";
      }
    ];
    userSettings = {
      nix.enableLanguageServer = false;
      rust-analyzer.checkOnSave.command = "clippy";
      editor.formatOnSave = false;
      editor.tabSize = 2;
      debug.allowBreakpointsEverywhere = true;

      #Neovim integration
      vscode-neovim.neovimExecutablePaths.linux = "${getExe config.programs.neovim.finalPackage}";
    };
  };
}
