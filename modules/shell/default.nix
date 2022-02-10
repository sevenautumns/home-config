{ pkgs, config, ... }: {
  imports = [ ./alacritty.nix ./git.nix ./fish.nix ./starship.nix ];
  home.packages = with pkgs; [ skim fd bat exa neovim ripgrep ];

  programs.nix-index.enable = true;
  programs.bash.enable = true;

  xdg.systemDirs.data = [
    "/usr/share"
    "/usr/local/share"
    "$HOME/.nix-profile/share"
    "$HOME/.share"
  ];
}
