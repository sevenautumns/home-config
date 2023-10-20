{ pkgs, config, lib, machine, inputs, ... }: {
  programs.helix = {
    enable = true;
    package =
      if (machine.arch == "x86_64-linux") then
      # inputs.helix.packages."${pkgs.system}".default
        pkgs.unstable.helix
      else
        pkgs.stable.helix;
    settings = {
      theme = "autumn";
      editor = {
        true-color = true;
        idle-timeout = 0;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        soft-wrap.enable = true;
      };
      keys.normal = {
        "^" = [ "select_mode" "goto_first_nonwhitespace" "normal_mode" ];
        "$" = [ "select_mode" "goto_line_end" "normal_mode" ];
        X = "extend_line_above";
        space.space = "file_picker";
        space.w = ":write";
        space.q = ":quit";
        space.o = ":reload";
        space.u = ":format";
        space.n = ":new";
        "C-left" = "move_prev_long_word_start";
        "C-right" = "move_next_long_word_end";
        "C-down" = [
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
        ];
        "C-up" = [
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
        ];
      };
      keys.insert = {
        up = "move_line_up";
        down = "move_line_down";
        left = "move_char_left";
        right = "move_char_right";
        "C-left" = "move_prev_long_word_start";
        "C-right" = "move_next_long_word_end";
        "C-down" = [
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
          "move_line_down"
        ];
        "C-up" = [
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
          "move_line_up"
        ];
      };
      keys.select = {
        "^" = [ "select_mode" "goto_first_nonwhitespace" "normal_mode" ];
        "$" = [ "select_mode" "goto_line_end" "normal_mode" ];
      };
    };
    languages.language = [
      {
        name = "rust";
        config = {
          checkOnSave.command = "clippy";
          procMacro.enable = true;
          diagnostics.disabled = [ "unresolved-proc-macro" ];
        };
      }
      {
        name = "toml";
        language-server = {
          command = "taplo";
          args = [ "lsp" "stdio" ];
        };
      }
      {
        name = "latex";
        language-server.command = "ltex-ls";
        config.ltex = {
          language = "en-GB";
          latex.commands = { "\\\\lstinline{}" = "dummy"; };
        };
      }
      {
        name = "nix";
        formatter.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        language-server.command = "nixd";
        file-types = [ "nix" ];
        scope = "source.nix";
        auto-format = true;
      }
      {
        name = "git-commit";
        scope = "git.commitmsg";
        roots = [ ];
        file-types = [ "COMMIT_EDITMSG" ];
        comment-token = "#";
        indent = {
          tab-width = 2;
          unit = "  ";
        };
        language-server.command = "ltex-ls";
      }
      {
        name = "markdown";
        language-server.command = "ltex-ls";
        file-types = [ "md" ];
        scope = "source.markdown";
        roots = [ ];
      }
    ];
  };

  home.sessionVariables.EDITOR = "${pkgs.helix}/bin/hx";

  home.packages = with pkgs; [
    (makeDesktopItem {
      name = "helix";
      desktopName = "Helix";
      exec =
        "${config.programs.alacritty.package}/bin/alacritty --title Helix --class helix -e ${config.programs.helix.package}/bin/hx %F";
      terminal = false;
      type = "Application";
    })

    # Debugging stuff
    lldb

    # Spelling checker
    ltex-ls

    # Language servers
    clang-tools # C-Style
    taplo # Toml
    cmake-language-server # Cmake
    texlab # LaTeX
    gopls # Go
    rnix-lsp # Nix
    # rust-analyzer # Rust
    sumneko-lua-language-server # Lua
    nodePackages.vim-language-server # Vim
    nodePackages.typescript-language-server # Typescript
    nodePackages.vscode-json-languageserver # JSON
    (if machine.arch == "x86_64-linux" then nixd else unstable.nixd)
  ];
}
