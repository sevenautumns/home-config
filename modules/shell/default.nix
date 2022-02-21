{ pkgs, config, host, ... }: {
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
    fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden --type f";
    fileWidgetOptions = [ "--preview='${pkgs.bat}/bin/bat {} --color=always'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --hidden --type d";
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

  programs.topgrade = {
    enable = true;
    settings = {
      disable = [ "nix" "home_manager" ];
      linux.arch_package_manager = "paru";
      commands = {
        nix-channel = "nix-channel --update";
        home-config = (builtins.replaceStrings [ "\n" ] [ "" ] ''
          cd ~/.config/nixpkgs &&
            nix flake update &&
            ${config.programs.fish.shellAliases.sw}
        '');
      };
    };
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
