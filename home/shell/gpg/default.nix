{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./svenatautumnal.asc;
        trust = "ultimate";
      }
    ];
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  # home.sessionVariables.SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent.ssh";
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryPackage = pkgs.pinentry-gnome3;
    grabKeyboardAndMouse = false;
  };
}
