{ pkgs, config, ... }: {
  imports = [ ./git.nix ./fish.nix ./starship.nix ./neovim.nix ./keyboard.nix ];
  home.packages = with pkgs; [
    fd
    ripgrep
    du-dust
    any-nix-shell
    lfs
    hyperfine
    calc
    neofetch
  ];

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd -E /net --hidden --type f";
    fileWidgetOptions = [ "--preview='${pkgs.bat}/bin/bat {} --color=always'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -E /net d--hidden --type d";
    changeDirWidgetOptions =
      [ "--preview='${pkgs.exa}/bin/exa --tree {} | head -200'" ];
    historyWidgetOptions = [ "--height 40%" "--layout=reverse" ];
  };

  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    enableFishIntegration = true;
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      dialect = "uk";
    };
  };

  programs.htop.enable = true;
  programs.bottom.enable = true;
  programs.bat.enable = true;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.pazi = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zsh.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
