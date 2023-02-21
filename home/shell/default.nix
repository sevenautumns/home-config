{ pkgs, lib, config, machine, ... }: {
  imports = [
    ./colors.nix
    ./git.nix
    ./helix.nix
    ./fish.nix
    ./starship.nix
    ./neovim.nix
    ./nu.nix
    ./keyboard.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    fd
    ripgrep
    du-dust
    any-nix-shell
    lfs
    hyperfine
    calc
    neofetch
    pulsemixer
  ];

  pam.yubico.authorizedYubiKeys.ids = [];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.skim = {
    enable = true;
    enableFishIntegration = true;
    fileWidgetCommand = "${pkgs.fd}/bin/fd -E /net --hidden --type f";
    fileWidgetOptions = [ "--preview='${pkgs.bat}/bin/bat {} --color=always'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -E /net --hidden --type d";
    changeDirWidgetOptions =
      [ "--preview='${pkgs.exa}/bin/exa --tree {} | head -200'" ];
    historyWidgetOptions = [ "--height 40%" "--layout=reverse" ];
  };

  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    enableFishIntegration = true;
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      dialect = "uk";
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts:
      [
        exts.pass-otp
        # exts.pass-import
        # exts.pass-audit
      ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
  };

  programs.tealdeer.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";
  services.gnome-keyring.enable = true;
  home.sessionVariables.SSH_AUTH_SOCK = if (machine.user == "frie_sv") then
    "/run/user/125030/keyring/ssh"
  else
    "/run/user/1000/keyring/ssh";

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

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
