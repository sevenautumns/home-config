{ pkgs, lib, config, machine, ... }: {
  accounts.email.accounts.google = {
    address = "friedrich122112@googlemail.com";
    mu.enable = true;
    flavor = "gmail.com";
    mbsync = {
      enable = true;
      create = "both";
      patterns = [
        "*"
        "![Gmail]*"
        "[Gmail]/Sent Mail"
        "[Gmail]/Important"
        "[Gmail]/Drafts"
        "[Gmail]/Trash"
      ];
    };
    msmtp.enable = true;
    realName = "Sven Friedrich";
    passwordCommand = "pass web/GoogleApplicationPassword";
    userName = "friedrich122112@googlemail.com";
  };
}
