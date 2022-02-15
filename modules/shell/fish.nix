{ pkgs, config, ... }: {
  programs.command-not-found.enable = false;
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

      # Hooks.
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
    '';
    shellInit = ''
      set -x BAT_THEME Nord
    '';
    shellAliases = {
      vim = "${pkgs.neovim}/bin/nvim";
      cat = "${pkgs.bat}/bin/bat --paging=never -p";
      sw =
        ''home-manager switch --flake $HOME/.config/nixpkgs#"$USER@$hostname"'';
      fmtnix = "${pkgs.fd}/bin/fd -e nix -X ${pkgs.nixfmt}/bin/nixfmt";
      fu = "fish_update_completions";
      update-background =
        "${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/Pictures/Wallpaper/";
    };
    functions.fish_greeting = { body = ""; };
  };
}
