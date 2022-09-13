{ pkgs, config, lib, machine, inputs, ... }: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages."${pkgs.system}".default;
    settings = {
      theme = "autumn";
      editor = {
        true-color = true;
        idle-timeout = 0;
        #lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
      };
      keys.normal = {
        "^" = "goto_first_nonwhitespace";
        "$" = "goto_line_end";
        space.space = "file_picker";
        space.w = ":write";
        space.q = ":quit";
        # space.c = ":buffer-close";
        space.o = ":reload";
        space.u = ":format";
        space.n = ":new";
      };
      keys.insert = {
        up = "move_line_up";
        down = "move_line_down";
        left = "move_char_left";
        right = "move_char_right";
      };
      keys.select = {
        "^" = "goto_line_start";
        "$" = "goto_line_end";
      };
    };
    languages = [
      {
        name = "rust";
        config = {
          checkOnSave.command = "clippy";
          cargo.allFeatures = true;
          procMacro.enable = true;
        };
      }
      {
        name = "latex";
        language-server.command = "ltex-ls";
      }
      {
        name = "nix";
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
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
    # Debugging stuff
    lldb

    # Spelling checker
    ltex-ls

    # Language servers
    clang-tools # C-Style
    cmake-language-server # Cmake
    texlab # LaTeX
    gopls # Go
    rnix-lsp # Nix
    rust-analyzer # Rust
    sumneko-lua-language-server # Lua
    nodePackages.vim-language-server # Vim
    nodePackages.typescript-language-server # Typescript
    nodePackages.vscode-json-languageserver # JSON
  ];
}
