{ pkgs, config, lib, machine, inputs, ... }: {
  programs.helix = {
    enable = true;
    package = if (machine.arch == "x86_64-linux") then
      inputs.helix.packages."${pkgs.system}".default
    else
      pkgs.stable.helix;
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
        "^" = [
          "select_mode"        
          "goto_first_nonwhitespace"
          "normal_mode"
        ];
        "$" = [
          "select_mode"        
          "goto_line_end"
          "normal_mode"
        ];
        space.space = "file_picker";
        space.w = ":write";
        space.q = ":quit";
        # space.c = ":buffer-close
        space.o = ":reload";
        space.u = ":format";
        space.n = ":new";
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
        "^" = [
          "select_mode"        
          "goto_first_nonwhitespace"
          "normal_mode"
        ];
        "$" = [
          "select_mode"        
          "goto_line_end"
          "normal_mode"
        ];
      };
    };
    languages = [
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
      }
      {
        name = "nix";
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        # language-server.command = "${inputs.nil.packages.${pkgs.system}.default}/bin/nil";
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
    taplo # Toml
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
