{
  pkgs,
  lib,
  config,
  machine,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  imports = [
    ./colors.nix
    ./git.nix
    ./gpg
    ./helix.nix
    ./fish.nix
    ./starship.nix
    ./neovim.nix
    ./nu.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    fd
    ripgrep
    dust
    any-nix-shell
    dysk
    hyperfine
    bluetuith
    calc
    neofetch
    pulsemixer
    yubikey-manager
    diceware
  ];

  pam.yubico.authorizedYubiKeys.ids = [ ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetCommand = "${getExe pkgs.fd} -E /net --hidden --type f";
    fileWidgetOptions = [ "--preview='${getExe pkgs.bat} {} --color=always'" ];
    changeDirWidgetCommand = "${getExe pkgs.fd} -E /net --hidden --type d";
    changeDirWidgetOptions = [ "--preview='${getExe pkgs.eza} --tree {} | head -200'" ];
    historyWidgetOptions = [
      "--height 40%"
      "--layout=reverse"
    ];
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-otp
      # exts.pass-import
      # exts.pass-audit
    ]);
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };

  programs.tealdeer.enable = true;

  services.gnome-keyring.enable = true;
  # home.sessionVariables.SSH_AUTH_SOCK = "/run/user/$UID/ssh-agent";
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      compression = true;
      controlMaster = "auto";
      controlPersist = "1m";
    };
    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519_sk
      IdentityFile ~/.ssh/id_ed25519
      # Fix resident Yubikey
      # https://bbs.archlinux.org/viewtopic.php?id=274571
      KexAlgorithms -sntrup761x25519-sha512@openssh.com
    '';
    matchBlocks."ft-ssy-stonks.intra.dlr.de".forwardAgent = true;
    matchBlocks."ft-ssy-grof.intra.dlr.de".forwardAgent = true;
    matchBlocks."lebenshilfe-uslar.de".forwardAgent = true;
    matchBlocks."192.168.178.2".forwardAgent = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "monokai";
      theme_background = false;
    };
  };

  programs.htop.enable = true;
  programs.bottom.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  home.sessionVariables.BAT_THEME = "base16";
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.pazi = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zsh.enable = true;

  programs.eza.enable = true;
}
