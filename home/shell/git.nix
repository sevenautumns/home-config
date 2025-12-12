{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  programs.git = {
    enable = true;
    signing = {
      key = "2FCAB71B";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Sven Friedrich";
        email = "sven@autumnal.de";
      };
      core.editor = config.home.sessionVariables.EDITOR;
      core.pager = "${getExe pkgs.delta}";
      pager.blame = "${getExe pkgs.delta}";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      alias = {
        st = "status";
        it = "commit";
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        lg = "lg1";
      };
    };
  };

  programs.lazygit.enable = true;

  home.packages = with pkgs; [ git-absorb ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      syntax-theme = "base16";
      navigate = true;
      line-numbers = true;
      diff-so-fancy = true;
      side-by-side = false;
    };
  };
}
