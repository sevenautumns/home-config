{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      table-mode

      vim-css-color
      vim-nix
      vim-toml
    ];
  };
}
