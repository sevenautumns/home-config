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
  };
}
