{ pkgs, config, host, lib, inputs, ... }: {

  # Only activate for laptops
  # https://github.com/yrashk/nix-home/blob/55fc51e1954184e0f5d9a00916963e2ce8b56d21/home.nix
  systemd.user.services.syndaemon = if host == "ft-ssy-sfnb" then {
    Unit = {
      Description = "syndaemon";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.xorg.xf86inputsynaptics}/bin/syndaemon -K -i 0.5";
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  } else
    { };
}
