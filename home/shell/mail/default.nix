{ pkgs, lib, config, machine, ... }: {
  imports = [ ./google.nix ./apple.nix ./tuc.nix ./ionos.nix ];

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  # programs.notmuch.enable = true;
  programs.himalaya = {
    enable = true;
    settings = {
      email-reading-verify-cmd = "gpg --verify -q";
      email-writing-sign-cmd = "gpg -o - -saq";
    };
    # settings = { watch-cmds = [ "mbsync -a" ]; };
  };
  # programs.astroid = {
  #   enable = true;
  # };
}
