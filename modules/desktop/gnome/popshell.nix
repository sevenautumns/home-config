{ pkgs, config, inputs, lib, ... }:
let
  pop-shell = (pkgs.gnomeExtensions.pop-shell.overrideAttrs (old: {
    src = inputs.pop-shell;
    version = "unstable-master_jammy";
  }));
  pop-launcher = (pkgs.pop-launcher.pop-launcher.overrideAttrs (old: {
    src = inputs.pop-launcher;
    version = "unstable-master";
    cargoSha256 = null;
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${inputs.pop-launcher}/Cargo.lock";
    };
  }));
in {
  home.packages = with pkgs; [ pop-shell pop-launcher ];

  home.file.".local/share/pop-launcher/plugins/web/config.ron".text = ''
    (
        rules: [
            (
                matches: ["arch"],
                queries: [(name: "Arch Wiki", query: "wiki.archlinux.org/index.php/" )]
            ),
            (
                matches: ["crates"],
                queries: [
                    (name: "Crates.io", query: "crates.io/search?q="),
                    (name: "Lib.rs", query: "lib.rs/search?q="),
                ]
            ),
            (
                matches: ["ddg", "duckduckgo"],
                queries: [(name: "DuckDuckGo", query: "duckduckgo.com/?q=")]
            ),
            (
                matches: ["gh", "github"],
                queries: [(name: "GitHub", query: "github.com/search?q=")]
            ),
            (
                matches: ["np", "nixpkgs"],
                queries: [(name: "Nix Packages", query: "search.nixos.org/packages?channel=unstable&query=test")]
            ),
            (
                matches: ["gs", "google"],
                queries: [(name: "Search", query: "google.com/search?q=")]
            ),
            (
                matches: ["yt", "youtube"],
                queries: [(name: "YouTube", query: "youtube.com/results?search_query=")]
            ),
        ]
    )
  '';

  xdg.configFile."pop-shell/config.json".text = builtins.toJSON {
    skiptaskbarhidden = [ ];
    log_on_focus = false;
    move_pointer_on_switch = true;
    default_pointer_position = "CENTER";
    float = [
      { class = "Authy Desktop"; }
      { class = "gnome-screenshot"; }
      { class = "jetbrains-toolbox"; }
      {
        class = "Steam";
        title = "^((?!Steam).)*$";
      }
      {
        class = "TelegramDesktop";
        title = "Media viewer";
      }
      { class = "zoom"; }
      {
        class = "syncplay";
        title = "Syncplay configuration";
      }
    ];
  };

  dconf.settings = {
    "org/gnome/shell/extensions/pop-shell" = {
      activate-launcher = [ "<Super>Space" ];
      tile-enter = [ "<Super>x" ];
      tile-orientation = [ "<Super>o" ];
      toggle-floating = [ "<Super><Shift>space" ];
      toggle-stacking-global = [ "<Super>z" "<Super>y" ];
      toggle-tiling = [ ];

      tile-by-default = true;
      show-title = false;
      active-hint = true;
      hint-color-rgba = "rgba(216, 222, 233, 1)";
      snap-to-grid = false;
      smart-gaps = true;

      # Focus Shifting
      focus-left = [ "<Super>Left" ];
      focus-down = [ "<Super>Down" ];
      focus-up = [ "<Super>Up" ];
      focus-right = [ "<Super>Right" ];

      # Tile Management Mode
      management-orientation = [ "o" ];
      tile-accept = [ "Return" ];
      tile-move-down = [ "Down" ];
      tile-move-left = [ "Left" ];
      tile-move-right = [ "Right" ];
      tile-move-up = [ "Up" ];
      tile-reject = [ "Escape" ];
      toggle-stacking = [ "s" ];

      # Resize in normal direction
      tile-resize-left = [ "<Shift>Left" ];
      tile-resize-down = [ "<Shift>Down" ];
      tile-resize-up = [ "<Shift>Up" ];
      tile-resize-right = [ "<Shift>Right" ];

      # Workspace Management -->
      pop-workspace-down = [ ];
      pop-workspace-up = [ ];
      pop-monitor-down = [ "<Super><Shift>Down" ];
      pop-monitor-up = [ "<Super><Shift>Up" ];
      pop-monitor-left = [ "<Super><Shift>Left" ];
      pop-monitor-right = [ "<Super><Shift>Right" ];
    };
  };
}
