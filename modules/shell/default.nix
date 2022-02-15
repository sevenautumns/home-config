{ pkgs, config, host, ... }: {
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

  programs.htop.enable = true;
  programs.bottom.enable = true;
  programs.bat.enable = true;
  programs.nix-index.enable = true;
  programs.bash.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  home.sessionVariables.PATH = if host == "neesama" then
  # Reorder PATH for non-Nix system
  # - Nix packages work flawlessly with unfavorable PATH-Order
  # - Arch packages don't
    (builtins.replaceStrings [ "\n" ] [ "" ] ''
      /usr/local/bin:
      /usr/bin:/bin:
      /usr/local/sbin:
      /usr/bin/site_perl:
      /usr/bin/vendor_perl:
      /usr/bin/core_perl:
      $HOME/.cargo/bin:
      $HOME/.nix-profile/bin:
      /nix/var/nix/profiles/default/bin
    '')
  else
    "$PATH:$HOME/.cargo/bin";

  xdg.systemDirs.data = [
    "/usr/share"
    "/usr/local/share"
    "$HOME/.nix-profile/share"
    "$HOME/.share"
  ];
}
