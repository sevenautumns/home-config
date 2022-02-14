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
      delta = {
        navigate = true;
        theme = "Nord";
      };
      #interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.git.delta = {
    enable = true;
    options = {
      syntax-theme = "Nord";
      diff-so-fancy = true;
    };
  };
}
