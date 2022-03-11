{ config, pkgs, lib, user, host, ... }:
let
  sw = pkgs.writeShellScriptBin "sw" ''
    home-manager switch --flake $HOME/.config/nixpkgs#"${user}@${host}"
  '';
in {
  imports = [ modules/desktop modules/shell options/default.nix ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  #xdg.configFile."test".text = "${config.theme.nord0}";
  xdg.enable = true;

  home.packages = [
    #pkgs.alacritty
    pkgs.unstable.xterm
    sw
  ];

  home.sessionVariables.PATH = if host == "neesama" then
  # Reorder PATH for non-Nix system
  # - Nix packages work flawlessly with unfavorable PATH-Order
  # - Arch packages don't
    (builtins.replaceStrings [ "\n" ] [ "" ] ''
      /usr/local/bin:
      /usr/bin:/bin:
      /usr/local/sbin:
      /usr/bin/site_perl:
      /usr/bin/vendor_perl:
      /usr/bin/core_perl:
      $HOME/.cargo/bin:
      $HOME/.nix-profile/bin:
      /nix/var/nix/profiles/default/bin
    '')
  else
    "$PATH:$HOME/.cargo/bin";

  xdg.systemDirs.data = [
    "/usr/share"
    "/usr/local/share"
    "$HOME/.nix-profile/share"
    "$HOME/.share"
  ];

  home.file = if host == "neesama" then {
    "GitRepos".source =
      config.lib.file.mkOutOfStoreSymlink "/media/ssddata/GitRepos";
  } else
    { };
}
