{ pkgs, config, ... }: {
  # TODO Use more professional email/name ?
  programs.git = {
    enable = true;
    userName = "autumnal";
    userEmail = "sven@autumnal.de";
    aliases = {
      st = "status";
      it = "commit";
    };
    extraConfig = {
      core = { editor = "${pkgs.neovim}/bin/nvim"; };
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
      side-by-side = true;
    };
  };
}
