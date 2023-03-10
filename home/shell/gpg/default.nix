{ pkgs, inputs, config, lib, ... }: {
  programs.gpg = {
    enable = true;
    publicKeys = [{
      source = ./svenatautumnal.asc;
      trust = "ultimate";
    }];
    settings = { keyserver = "hkps://keys.openpgp.org"; };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentryFlavor = "gnome3";
  };
}
