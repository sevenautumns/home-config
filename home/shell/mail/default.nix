{ pkgs, lib, config, machine, ... }: {
  imports = [ ./google.nix ./apple.nix ./tuc.nix ./ionos.nix ];

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.mu.enable = true;
  programs.himalaya = {
    enable = true;
    # settings = { watch-cmds = [ "mbsync -a" ]; };
  };
}
