{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
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
      ${getExe pkgs.any-nix-shell} fish | source
    '';
    shellAliases = {
      cat = "${getExe pkgs.bat} --paging=never -p";
      fmtnix = "${getExe pkgs.fd} -e nix -X ${getExe pkgs.nixfmt-rfc-style}";
      fu = "fish_update_completions";
      zf = ''z --pipe="sk --layout=reverse"'';
      # zf = ''z --pipe="sk --height 40% --layout=reverse"'';
    };
    functions = {
      fish_greeting = {
        body = "";
      };
      fish_user_key_bindings = {
        description = "Set custom key bindings";
        body = ''
          bind \cy pazi_skim_binding
          bind \cz pazi_skim_binding
          bind \cb broot_binding
          bind \ct broot_dir_binding
        '';
      };
      broot_binding = {
        description = "Broot binding with query and repaint";
        body = ''
          set -l commandline (__skim_parse_commandline)
          set -l query $commandline[2]
          commandline (commandline --cut-at-cursor)
          br --cmd $query
          cancel

          commandline -t ""
          commandline -f repaint
        '';
      };
      broot_dir_binding = {
        description = "Broot dir-only binding with query and repaint";
        body = ''
          set -l commandline (__skim_parse_commandline)
          set -l query $commandline[2]
          commandline (commandline --cut-at-cursor)
          br --only-folders --cmd $query
          cancel

          commandline -t ""
          commandline -f repaint
        '';
      };
      pazi_skim_binding = {
        description = "Pazi binding with query and repaint";
        body = ''
          set -l commandline (__skim_parse_commandline)
          set -l query $commandline[2]
          commandline (commandline --cut-at-cursor)
          ${config.programs.fish.shellAliases.zf} $query

          commandline -t ""
          commandline -f repaint
        '';
      };
    };
  };
}
