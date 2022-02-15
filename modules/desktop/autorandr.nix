{ pkgs, config, ... }:
let
  monitor = {
    asus-240-dp =
      "00ffffffffffff0006b38f2701010101281e0104b53c22783b9b95a5574ea3260c5054b7ef0081c081cf8100810fd1c0d1d9d1e8d1fc023a801871382d40582c450056502100001e000000fd0030f0ffff42010a202020202020000000fc005647323739514d0a2020202020000000ff004c394c4d51533235373533340a013d020328f14d90010203111213040e0f1d1e1f2309070783010000e305e001e6060701606000e2006afc7e8088703812401820350056502100001e23e88078703887402020980c56502100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2";
    samsung-4k-hdmi =
      "00ffffffffffff004c2d4e0c46584d30081a0103803d23782a5fb1a2574fa2280f5054bfef80714f810081c081809500a9c0b300010104740030f2705a80b0588a0060592100001e000000fd00184b1e5a1e000a202020202020000000fc00553238453539300a2020202020000000ff00485450483230343131360a20200115020324f0495f10041f130312202223090707830100006d030c001000803c201060010203023a801871382d40582c450060592100001e023a80d072382d40102c458060592100001e011d007251d01e206e28550060592100001e565e00a0a0a029503020350060592100001a0000000000000000000000000000000000000067";
  };
in {

  programs.autorandr = {
    enable = true;
    hooks.postswitch = {
      update-background = ''
        systemctl --user restart polybar.service &
        ${config.programs.fish.shellAliases.update-background}
        ${pkgs.betterlockscreen}/bin/betterlockscreen -w
      '';
    };
    profiles = {
      "clz" = {
        fingerprint = {
          DP-0 = monitor.asus-240-dp;
          HDMI-0 = monitor.samsung-4k-hdmi;
        };
        config = {
          DP-0 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "2560x0";
            mode = "1920x1080";
            rate = "239.76";
          };
          HDMI-0 = {
            enable = true;
            crtc = 1;
            position = "0x0";
            mode = "2560x1440";
            rate = "59.95";
          };
        };
      };
    };
  };
}