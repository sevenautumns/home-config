{
  pkgs,
  config,
  lib,
  machine,
  inputs,
  ...
}:
let
  inherit (lib.meta) getExe getExe';
in
{
  programs.helix = {
    enable = true;
    package = if (machine.arch == "x86_64-linux") then pkgs.unstable.helix else pkgs.stable.helix;
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
          formatter.command = "${getExe pkgs.nixfmt-rfc-style}";
          language-servers = [ "nixd" ];
          file-types = [ "nix" ];
          scope = "source.nix";
          auto-format = true;
        }
        {
          name = "python";
          formatter = {
            command = "black";
            args = [
              "--quiet"
              "-"
            ];
          };
          language-servers = [ "pyright" ];
          auto-format = true;
          roots = [ "pyproject.toml" ];
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
          language-servers = [
            "ltex"
            "zk"
          ];
          file-types = [
            "md"
            "markdown"
          ];
          scope = "source.md";
          roots = [
            ".zk"
            ".git"
          ];
        }
      ];
      language-server = {
        rust-analyzer.config = {
          checkOnSave = true;
          check.command = "clippy";
          # checkOnSave.command = "clippy";
          procMacro.enable = true;
          diagnostics.disabled = [ "unresolved-proc-macro" ];
        };
        taplo = {
          command = "taplo";
          args = [
            "lsp"
            "stdio"
          ];
        };
        ltex = {
          command = "ltex-ls";
          config.ltex = {
            language = "en-GB";
            latex.commands = {
              "\\\\lstinline{}" = "dummy";
            };
          };
        };
        zk = {
          command = "zk";
          args = [ "lsp" ];
        };
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
        nixd.command = "nixd";
      };
      debugger = {
        command = "${getExe' pkgs.lldb "lldb-vscode"}";
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

  home.sessionVariables.EDITOR = "${getExe pkgs.helix}";

  home.packages = with pkgs; [
    (makeDesktopItem {
      name = "helix";
      desktopName = "Helix";
      exec = "alacritty --title Helix --class helix -e ${getExe config.programs.helix.package} %F";
      terminal = false;
      type = "Application";
    })

    # Debugging stuff
    lldb

    # Spelling checker
    ltex-ls

    pyright

    # Language servers
    clang-tools # C-Style
    taplo # Toml
    cmake-language-server # Cmake
    texlab # LaTeX
    gopls # Go
    # rnix-lsp # Nix
    zk # Zettelkasten
    # rust-analyzer # Rust
    lua-language-server # Lua
    nodePackages.vim-language-server # Vim
    nodePackages.typescript-language-server # Typescript
    nodePackages.vscode-json-languageserver # JSON
    unstable.nixd # (if machine.arch == "x86_64-linux" then nixd else unstable.nixd)
    tinymist
  ];
}
