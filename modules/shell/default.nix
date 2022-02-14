{ pkgs, config, ... }: {
  imports =
    [ ./alacritty.nix ./git.nix ./fish.nix ./starship.nix ./neovim.nix ];
  home.packages = with pkgs; [ fd ripgrep ];

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;
  programs.nix-index.enable = true;
  programs.bash.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  xdg.systemDirs.data = [
    "/usr/share"
    "/usr/local/share"
    "$HOME/.nix-profile/share"
    "$HOME/.share"
  ];
}
