{ pkgs, config, ... }: {
  imports = [ ./alacritty ./git.nix ./fish.nix ./starship.nix ];
  home.packages = with pkgs; [ skim fd bat exa neovim ripgrep ];

  programs.nix-index.enable = true;

  xdg.configFile."paru/paru.conf".text = ''
    [options]
    Devel
    Provides
    DevelSuffixes = -git -cvs -svn -bzr -darcs -always -hg
    BottomUp 
  '';

}
