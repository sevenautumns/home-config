{ pkgs, config, ... }: {
  programs.git = {
    enable = true;
    userName = "autumnal";
    userEmail = "friedrich122112@me.com";
    aliases = { st = "status"; };
  };
}
