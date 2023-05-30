{ pkgs, config, lib, inputs, ... }: {
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    extensions = with pkgs.vscode-extensions;
      with pkgs.vscode-utils; [
        bbenoist.nix
        streetsidesoftware.code-spell-checker
        matklad.rust-analyzer
        vadimcn.vscode-lldb
        bungcip.better-toml
        james-yu.latex-workshop
        mkhl.direnv
        oderwat.indent-rainbow
        jnoortheen.nix-ide
      ];
    keybindings = [
      {
        "key" = "ctrl+shift+c";
        "command" = "editor.action.clipboardCopyAction";
      }
      {
        "key" = "ctrl+shift+v";
        "command" = "editor.action.clipboardPasteAction";
      }
      {
        "key" = "ctrl+tab";
        "command" = "workbench.action.showAllEditors";
      }
    ];
    userSettings = {
      nix.enableLanguageServer = false;
      rust-analyzer.checkOnSave.command = "clippy";
      editor.formatOnSave = false;
      editor.tabSize = 2;
      debug.allowBreakpointsEverywhere = true;

      #Neovim integration
      vscode-neovim.neovimExecutablePaths.linux =
        "${config.programs.neovim.finalPackage}/bin/nvim";

      # Language
      # languageToolLinter.serviceType = "external";
      # languageToolLinter.external.url ="http://localhost:9510";
      # languageToolLinter.languageTool.language = "en-GB";
      # languageToolLinter.lintOnChange = true;
    };
  };

  # systemd.user.services."languagetool-http-server" = {
  #   Unit = {
  #     Description = "Languagetool HTTP server";
  #     PartOf = [ "graphical-session-pre.target" ];
  #     After = [ "graphical-session.target" ];
  #   };

  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server org.languagetool.server.HTTPServer --port 9510 --allow-origin '*'";
  #     Restart = "always";
  #   };

  #   Install = { WantedBy = [ "graphical-session.target" ]; };
  # };
}
