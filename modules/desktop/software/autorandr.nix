{ pkgs, config, ... }:
let
  monitor = {
    asus-240-dp =
      "00ffffffffffff0006b38f2701010101281e0104b53c22783b9b95a5574ea3260c5054b7ef0081c081cf8100810fd1c0d1d9d1e8d1fc023a801871382d40582c450056502100001e000000fd0030f0ffff42010a202020202020000000fc005647323739514d0a2020202020000000ff004c394c4d51533235373533340a013d020328f14d90010203111213040e0f1d1e1f2309070783010000e305e001e6060701606000e2006afc7e8088703812401820350056502100001e23e88078703887402020980c56502100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2";
    samsung-4k-hdmi =
      "00ffffffffffff004c2d4e0c46584d30081a0103803d23782a5fb1a2574fa2280f5054bfef80714f810081c081809500a9c0b300010104740030f2705a80b0588a0060592100001e000000fd00184b1e5a1e000a202020202020000000fc00553238453539300a2020202020000000ff00485450483230343131360a20200115020324f0495f10041f130312202223090707830100006d030c001000803c201060010203023a801871382d40582c450060592100001e023a80d072382d40102c458060592100001e011d007251d01e206e28550060592100001e565e00a0a0a029503020350060592100001a0000000000000000000000000000000000000067";
    latitude-5521 =
      "00ffffffffffff000dae291500000000231e0104a522137802ee95a3544c99260f505400000001010101010101010101010101010101363680a0703820405036680058c11000001a363680a0703836415036680058c11000001a000000fe004b52315630803135364843450a0000000000024101a8001000000a010a202000f1";
    darvin-lg =
      "00ffffffffffff001e6da475010101010811010380462778ead9b0a357499c2511494b810800010101010101454001016140010101011b2150a051001e3048883500bc882100001c4e1f008051001e3040803700bc8821000018000000fc004c472054560a20202020202020000000fd00324b1c430f000a20202020202001be020323f15001071602031112130414852021221f10230907078301000065030c001000011d008051d01c2040803500bc882100001e8c0ad08a20e02d10103e9600138e210000188c0aa01451f01600267c4300c48e21000098011d8018711c1620582c2500c48e2100009e0000000000000000000000000000000000000000ab";
  };
in {

  programs.autorandr = {
    enable = true;
    hooks.postswitch = {
      update-background = ''
        systemctl --user restart polybar.service &
        ${config.programs.fish.shellAliases.update-background}
        ${config.programs.fish.shellAliases.load-background}
      '';
    };
    profiles = {
      "clz" = {
        fingerprint = {
          DP-2 = monitor.asus-240-dp;
          HDMI-0 = monitor.samsung-4k-hdmi;
        };
        config = {
          DP-2 = {
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
      "latitude-no-screen" = {
        fingerprint = { eDP-1 = monitor.latitude-5521; };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "latitude-darvin" = {
        fingerprint = {
          eDP-1 = monitor.latitude-5521;
          HDMI-1 = monitor.darvin-lg;
        };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          HDMI-1 = {
            enable = true;
            crtc = 1;
            position = "1920x0";
            mode = "1360x768";
            rate = "59.80";
          };
        };
      };
    };
  };
}
