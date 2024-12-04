{ pkgs, config, lib, ... }:
let
  inherit (lib.meta) getExe;
in
{
  programs.git = {
    enable = true;
    userName = "Sven Friedrich";
    userEmail = "sven@autumnal.de";
    signing.key = "2FCAB71B";
    aliases = {
      st = "status";
      it = "commit";
      lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg = "lg1";
    };
    extraConfig = {
      commit.gpgsign = true;
      core.editor = config.home.sessionVariables.EDITOR;
      core.pager = "${getExe pkgs.delta}";
      pager.blame = "${getExe pkgs.delta}";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.lazygit.enable = true;

  home.packages = with pkgs; [ git-absorb ];

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
