{ config, pkgs, lib, machine, inputs, ... }:
let
  host = machine.host;
  user = machine.user;
  headless = machine.headless;
  sw = pkgs.writeShellScriptBin "sw" ''
    home-manager switch --flake $HOME/.config/nixpkgs#"${user}@${host}" $@
  '';
  sw-sys = pkgs.writeShellScriptBin "sw-sys" ''
    sudo nixos-rebuild switch --flake $HOME/.config/nixpkgs#"${host}" $@
  '';
  hinted = { };
in
{
  imports = [ ./shell ] ++ lib.optionals (!headless) [ ./desktop ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  xdg.enable = true;

  home.packages = [
    #pkgs.alacritty
    pkgs.unstable.xterm
    sw
  ] ++ lib.optionals (machine.managed-nixos) [ sw-sys ];

  home.sessionVariables = {
    LANGUAGE = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LANG = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    # TZ = "${pkgs.tzdata}/share/zoneinfo/Asia/Tokyo";
  };

  targets.genericLinux.enable = !machine.nixos;
  home.sessionVariables.PATH =
    if !machine.nixos then
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

  home.file =
    if host == "vivi" then {
      "GitRepos".source =
        config.lib.file.mkOutOfStoreSymlink "/media/ssddata/GitRepos";
    } else
      { };
}
