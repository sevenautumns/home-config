{
  pkgs,
  config,
  flakeRoot,
  ...
}:
{
  age.secrets = {
    rclone-mega = {
      file = flakeRoot + "/secrets/rclone-mega.age";
    };
    paperless-restic-password = {
      file = flakeRoot + "/secrets/paperless-restic-password.age";
    };
  };
  services.restic = {
    backups.paperless = {
      initialize = true;
      timerConfig = {
        OnCalendar = "00/3:00";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
        "--keep-yearly 12"
      ];
      paths = [ "/media/paperless/media/documents/originals" ];
      repository = "rclone:mega-paperless-crypt:/";
      passwordFile = config.age.secrets.paperless-restic-password.path;
      rcloneConfigFile = config.age.secrets.rclone-mega.path;
    };
  };
}
