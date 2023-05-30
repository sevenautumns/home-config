{ pkgs, lib, config, machine, ... }: {
  accounts.email.accounts.ionos = {
    address = "sven@autumnal.de";
    imap.host = "imap.ionos.de";
    imap.port = 993;
    imap.tls.enable = true;
    mu.enable = true;
    mbsync = {
      enable = true;
      create = "both";
      patterns = [ "INBOX" "*" "!Entwürfe" ];
    };
    primary = true;
    msmtp.enable = true;
    himalaya = {
      enable = true;
      backend = "maildir";
      sender = "smtp";
    };
    # astroid.enable = true;
    # astroid.sendMailCommand = "msmtpq --read-envelope-from --read-recipients";
    # notmuch.enable = true;
    realName = "Sven Friedrich";
    passwordCommand = "pass web/IonosAutumnal";
    smtp.host = "smtp.ionos.de";
    smtp.port = 587;
    smtp.tls.enable = true;
    smtp.tls.useStartTls = true;
    userName = "sven@autumnal.de";
    folders = {
      drafts = "Entwürfe";
      sent = "Gesendete Objekte";
      trash = "Papierkorb";
    };
    gpg = {
      key = "2FCAB71B";
      signByDefault = true;
    };
  };
}
