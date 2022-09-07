{ pkgs, config, lib, machine, ... }:
{
  programs.helix.enable = true;  
  programs.helix.settings.theme = "autumn";
  home.packages = with pkgs; [
    # Debugging stuff
    lldb

    # Language servers
    clang-tools # C-Style
    cmake-language-server # Cmake
    texlab # LaTeX
    gopls # Go 
    rnix-lsp # Nix
    rust-analyzer # Rust
    sumneko-lua-language-server # Lua
    nodePackages.vim-language-server # Vim
    nodePackages.typescript-language-server # Typescript
    nodePackages.vscode-json-languageserver # JSON
  ];
}
