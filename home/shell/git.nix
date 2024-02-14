{ pkgs, config, ... }: {
  programs.git = {
    enable = true;
    userName = "Sven Friedrich";
    userEmail = "sven@autumnal.de";
    signing.key = "2FCAB71B";
    aliases = {
      st = "status";
      it = "commit";
    };
    extraConfig = {
      commit.gpgsign = true;
      core.editor = config.home.sessionVariables.EDITOR;
      core.pager = "${pkgs.delta}/bin/delta";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.lazygit.enable = true;

  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "base16";
      navigate = true;
      line-numbers = true;
      diff-so-fancy = true;
      side-by-side = false;
    };
  };
}
