{ pkgs, config, ... }: {
  # TODO Use more professional email/name ?
  programs.git = {
    enable = true;
    userName = "autumnal";
    userEmail = "friedrich122112@me.com";
    aliases = {
      st = "status";
      it = "commit";
    };
    extraConfig = {
      core.pager = "${pkgs.delta}/bin/delta";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "Nord";
      navigate = true;
      line-numbers = true;
      diff-so-fancy = true;
      side-by-side = true;
    };
  };
}
