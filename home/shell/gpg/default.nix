{ pkgs, inputs, config, lib, ... }: {
  programs.gpg = {
    enable = true;
    publicKeys = [{
      source = ./svenatautumnal.asc;
      trust = "ultimate";
    }];
    settings = { keyserver = "hkps://keys.openpgp.org"; };
  };

  home.sessionVariables.SSH_AUTH_SOCK = "/run/user/$UID/gnupg/S.gpg-agent";
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };
}
