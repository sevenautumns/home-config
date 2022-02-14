{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      table-mode

      vim-css-color
      vim-grammarous
      vim-nix
      vim-toml
    ];
  };
}
