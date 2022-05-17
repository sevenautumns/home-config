{ config, pkgs, lib, machine, ... }:
let
  host = machine.host;
  user = machine.user;
  headless = machine.headless;
  sw = pkgs.writeShellScriptBin "sw" ''
    home-manager switch --flake $HOME/.config/nixpkgs#"${user}@${host}"
  '';
in {
  imports = [ modules/shell options/default.nix ]
    ++ lib.optionals (!headless) [ modules/desktop ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  #xdg.configFile."test".text = "${config.theme.nord0}";
  xdg.enable = true;

  #TODO use hinted roboto

  home.packages = [
    #pkgs.alacritty
    pkgs.unstable.xterm
    sw
  ];

  targets.genericLinux.enable = !machine.nixos;
  home.sessionVariables.PATH = if !machine.nixos then
  ## Reorder PATH for non-Nix system
  ## - Nix packages work flawlessly with unfavorable PATH-Order
  ## - Arch packages don't
    (builtins.replaceStrings [ "\n" ] [ "" ] ''
      /usr/local/bin:
      /usr/bin:/bin:
      /usr/local/sbin:
      $HOME/.cargo/bin:
      $PATH
    '')
  else
    "$PATH:$HOME/.cargo/bin";

  #xdg.systemDirs.data = [
  #  "/usr/share"
  #  "/usr/local/share"
  #  "$HOME/.nix-profile/share"
  #  "$HOME/.share"
  #];

  home.file = if host == "neesama" then {
    "GitRepos".source =
      config.lib.file.mkOutOfStoreSymlink "/media/ssddata/GitRepos";
  } else
    { };
}
