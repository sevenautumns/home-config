{ pkgs, ... }: {
  services = {
    syncthing = {
      enable = true;
      user = "autumnal";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "neesama" = {
          id =
            "COQUTKR-F2BGBH4-FSV2IL5-VR75ZZN-A5FMC6Z-QIPNDVB-SKKGJLZ-RHOUYAB";
        };
      };
      folders = {
        "Music" = {
          id = "kkrjx-7scje";
          path = "/media/music";
          devices = [ "neesama" ];
        };
      };
    };
  };
}
