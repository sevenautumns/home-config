{ config, lib, pkgs, modulesPath, ... }: {
  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;
  programs.steam.gamescopeSession.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    steam-fhsenv = pkgs.steam-fhsenv.overrideAttr (orig: {
      extraProfile = ''
        export SDL_JOYSTICK_DISABLE_UDEV=1
      '';
    });
  };

  services.flatpak.enable = true;

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [ gamescope mangohud ];
}

