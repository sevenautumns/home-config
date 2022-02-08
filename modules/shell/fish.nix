{ pkgs, config, ... }: {    programs.command-not-found.enable = false;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      #
      # COLOR THEME
      #
      set -g fish_color_autosuggestion '555'  'brblack'
      set -g fish_color_cancel -r
      set -g fish_color_command --bold
      set -g fish_color_comment red
      set -g fish_color_cwd green
      set -g fish_color_cwd_root red
      set -g fish_color_end brmagenta
      set -g fish_color_error brred
      set -g fish_color_escape 'bryellow'  '--bold'
      set -g fish_color_history_current --bold
      set -g fish_color_host normal
      set -g fish_color_match --background=brblue
      set -g fish_color_normal normal
      set -g fish_color_operator bryellow
      set -g fish_color_param cyan
      set -g fish_color_quote yellow
      set -g fish_color_redirection brblue
      set -g fish_color_search_match 'bryellow'  '--background=brblack'
      set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
      set -g fish_color_user brgreen
      set -g fish_color_valid_path --underline
      # Hooks. Starship is sourced by programs.starship.enableFishIntegration
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
    '';
    shellInit = ''
      source ${pkgs.skim}/share/skim/key-bindings.fish
      function fish_user_key_bindings
        skim_key_bindings
      end
      set -x FZF_DEFAULT_OPTS "--preview='${pkgs.bat}/bin/bat {} --color=always'" \n
      set -x SKIM_DEFAULT_COMMAND "${pkgs.ripgrep}/bin/rg --files || ${pkgs.fd}/bin/fd || ${pkgs.findutils}/bin/find ."
    '';
    shellAliases = {
      ls = "${pkgs.exa}/bin/exa";
      find = "${pkgs.fd}/bin/fd";
      vim = "${pkgs.neovim}/bin/nvim";
      cat = "${pkgs.bat}/bin/bat --paging=never -p";
      sw = "home-manager switch --flake /home/autumnal/.config/nixpkgs#\"autumnal@neesama\"";
      update-background =
        "betterlockscreen -u ~/Pictures/Wallpaper/venti-nord.png --display 1 -u ~/Pictures/Wallpaper/ganyu-nord.png";
    };
  };
}
