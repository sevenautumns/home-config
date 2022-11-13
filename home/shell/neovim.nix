{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      vnoremap y "+y 
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig

      table-mode

      vim-css-color
      vim-nix
      vim-toml
    ];
  };
  home.packages = with pkgs; [ xclip ];
}
