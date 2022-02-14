{ pkgs, config, ... }: {
  imports = [
    ./alacritty.nix
    ./git.nix
    ./fish.nix
    ./starship.nix
    ./neovim.nix
    ./keyboard.nix
  ];
  home.packages = with pkgs; [ fd ripgrep du-dust any-nix-shell ];

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand =
      "${pkgs.ripgrep}/bin/rg --files || ${pkgs.fd}/bin/fd || ${pkgs.findutils}/bin/find .";
    defaultOptions = [ "--preview='${pkgs.bat}/bin/bat {} --color=always'" ];
  };

  programs.fzf = {
    enable = true;
    defaultCommand = config.programs.skim.defaultCommand;
    defaultOptions = config.programs.skim.defaultOptions;
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
