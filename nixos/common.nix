{ lib, pkgs, info, ... }: {
  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  services.journald.extraConfig = "SystemMaxUse=250M";
  services.udev.packages = [ pkgs.yubikey-personalization ];
  #boot.kernel.sysctl = {
  #  "vm.oom-kill" = 0;
  #  "vm.overcommit_memory" = 2;
  #  "vm.overcommit_ratio" = 200; # 200% overcommit
  #};
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  nix = {
    settings.trusted-users = [ "admin" "autumnal" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;

  boot.enableContainers = false;

  # enable zerotier virtual switch
  services.zerotierone = {
    enable = true;
    # package = pkgs.zerotierone.overrideAttrs (orig: {
    #   buildInputs = orig.buildInputs ++ [ pkgs.miniupnpc pkgs.libnatpmp ];
    # });
    # package = pkgs.stable.zerotierone;
    joinNetworks = [
      "565799d8f6299e0c" # Network for my devices
    ];
  };

  networking.extraHosts = ''
    10.0.0.1 neesama
    10.3.0.0 tenshi
    10.4.0.0 index
  '';

  location = {
    provider = "manual";
    latitude = 51.8;
    longitude = 10.3;
  };

  # enable openssh
  environment.systemPackages = with pkgs; [ openssh git ];
  services.openssh = {
    enable = true;
    settings.passwordAuthentication = false;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
    };
  };

  # networking.networkmanager.enable = true;
  # services.wg-netmanager.enable = true;

  fonts.fontDir.enable = true;

  console = {
    font = "t0-16-uni.psf";
    colors = [
      "292929" # black (color0)
      "f05e48" # red (color1)
      "8daf67" # green (color2)
      "fad566" # yellow (color3)
      "81a2be" # blue (color4)
      "b294bb" # magenta (color5)
      "86c1b9" # cyan (color6)
      "f3f2cc" # white (color7)

      "3a3a3a" # black (color8)
      "f16b57" # red (color9)
      "96b573" # green (color10)
      "fad872" # yellow (color11)
      "7aa6da" # blue (color12)
      "c397d8" # magenta (color13)
      "90c6bf" # cyan (color14)
      "e8e8e8" # white (color15)
    ];
    packages = [ pkgs.uw-ttyp0 ];
  };

  security.sudo.extraRules = [{
    users = [ "admin" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  users.users.admin = {
    uid = 1001;
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp autumnal@neesama"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6 frie_sv@ft-ssy-sfnb"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkjuSM9mpcCFonZWaW+onrYr+mBjKzykeUWexTjImw0 autumnal@tenshi"
    ];
  };

  users.users.autumnal = {
    uid = 1000;
    isNormalUser = true;
    extraGroups =
      [ "wheel" "disk" "input" "audio" "video" "networkmanager" "docker" ];
    shell = pkgs.fish;
    home = "/home/autumnal";
    description = "Sven Friedrich";
    hashedPassword =
      "$6$C2lvYMnUwU$fHgjzsQRizvJclKHgscbXiPjrFp0Zm5jvC7Qi1wBdn6poFZ.qDpqmqmuW2UcrT9G.sccZ1W6Htx4Qszf0id68/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp autumnal@neesama"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6 frie_sv@ft-ssy-sfnb"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkjuSM9mpcCFonZWaW+onrYr+mBjKzykeUWexTjImw0 autumnal@tenshi"
    ];
  };
}

