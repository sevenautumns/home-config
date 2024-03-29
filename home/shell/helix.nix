{ pkgs, config, lib, machine, inputs, ... }: {
  programs.helix = {
    enable = true;
    package =
      if (machine.arch == "x86_64-linux") then
        pkgs.unstable.helix
      else
        pkgs.stable.helix;
    settings = {
      theme = "autumn";
      editor = {
        true-color = true;
        lsp.display-messages = true;
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
      };
      keys.insert = {
        up = "move_line_up";
        down = "move_line_down";
        left = "move_char_left";
        right = "move_char_right";
      };
      keys.select = {
        "^" = [ "select_mode" "goto_first_nonwhitespace" "normal_mode" ];
        "$" = [ "select_mode" "goto_line_end" "normal_mode" ];
      };
    };
    languages = {
      language = [
        {
          name = "toml";
          language-servers = [ "taplo" ];
        }
        {
          name = "latex";
          language-servers = [ "ltex" ];
        }
        {
          name = "nix";
          formatter.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          language-servers = [ "nixd" ];
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
          language-servers = [ "ltex" ];
        }
        {
          name = "markdown";
          language-servers = [ "ltex" ];
          file-types = [ "md" ];
          scope = "source.markdown";
          roots = [ ];
        }
      ];
      language-server = {
        rust-analyzer.config = {
          checkOnSave.command = "clippy";
          procMacro.enable = true;
          diagnostics.disabled = [ "unresolved-proc-macro" ];
        };
        taplo = {
          command = "taplo";
          args = [ "lsp" "stdio" ];
        };
        ltex = {
          command = "ltex-ls";
          config.ltex = {
            language = "en-GB";
            latex.commands = { "\\\\lstinline{}" = "dummy"; };
          };
        };
        nixd.command = "nixd";
      };
      debugger = {
        command = "${pkgs.lldb}/bin/lldb-vscode";
        name = "lldb-vscode";
        port-arg = "--port {}";
        transport = "tcp";
        templates = [
          {
            name = "binary";
            request = "launch";
            completion = [
              {
                completion = "filename";
                name = "binary";
              }
            ];
            args = {
              program = "{0}";
              runInTerminal = true;
            };
          }
        ];
      };
    };
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
