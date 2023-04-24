{ pkgs, lib, config, machine, ... }: {
  accounts.email.accounts.ionos = {
    address = "sven@autumnal.de";
    imap.host = "imap.ionos.de";
    mu.enable = true;
    mbsync = {
      enable = true;
      create = "both";
      patterns = [ "INBOX" "*" "!Entwürfe" ];
    };
    primary = true;
    msmtp.enable = true;
    realName = "Sven Friedrich";
    passwordCommand = "pass web/IonosAutumnal";
    smtp.host = "smtp.ionos.de";
    userName = "sven@autumnal.de";
  };
}
