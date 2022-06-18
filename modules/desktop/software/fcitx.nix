{ pkgs, inputs, config, lib, ... }:
let
  default-keyboard = config.home.keyboard.layout
    + (if config.home.keyboard.variant == "us" then "-us" else "");
  fcitx5-adwaita = pkgs.stdenv.mkDerivation rec {
    name = "fcitx5-adwaita";
    version = "git";
    src = inputs.fcitx5-adwaita;
    unpackPhase = "mkdir -p $out/Adwaita-dark";
    installPhase = "cd ${src} && cp -r * $out/Adwaita-dark";
    # 
  };

in {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-lua
      libsForQt5.fcitx5-qt
      fcitx5-gtk
    ];
  };

  home.file.".local/share/fcitx5/themes/".source = fcitx5-adwaita;

  xdg.configFile = {
    "fcitx5/config" = {
      force = true;
      text = lib.generators.toINI { } {
        Hotkey = {
          # Enumerate when press trigger key repeatedly
          EnumerateWithTriggerKeys = true;
          # Temporally switch between first and current Input Method
          AltTriggerKeys = "";
          # Enumerate Input Method Forward
          EnumerateForwardKeys = "";
          # Enumerate Input Method Backward
          EnumerateBackwardKeys = "";
          # Skip first input method while enumerating
          EnumerateSkipFirst = false;
        };
        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
          "1" = "Zenkaku_Hankaku";
          "2" = "Hangul";
        };
        "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
        "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
        "Hotkey/ActivateKeys"."0" = "Hangul_Hanja";
        "Hotkey/DeactivateKeys"."0" = "Hangul_Romaja";
        "Hotkey/PrevPage"."0" = "Up";
        "Hotkey/NextPage"."0" = "Down";
        "Hotkey/PrevCandidate"."0" = "Shift+Tab";
        "Hotkey/NextCandidate"."0" = "Tab";
        "Hotkey/TogglePreedit"."0" = "Control+Alt+P";
        Behavior = {
          # Active By Default
          ActiveByDefault = false;
          # Share Input State
          ShareInputState = "All";
          # Show preedit in application
          PreeditEnabledByDefault = true;
          # Show Input Method Information when switch input method
          ShowInputMethodInformation = true;
          # Show Input Method Information when changing focus
          showInputMethodInformationWhenFocusIn = false;
          # Show compact input method information
          CompactInputMethodInformation = true;
          # Show first input method information
          ShowFirstInputMethodInformation = true;
          # Default page size
          DefaultPageSize = 5;
          # Force Enabled Addons
          EnabledAddons = "";
          # Force Disabled Addons
          DisabledAddons = "";
          # Preload input method to be used by default
          PreloadInputMethod = true;
        };

      };
    };
    "fcitx5/conf/classicui.conf" = {
      force = true;
      text = lib.generators.toINIWithGlobalSection { } {
        globalSection = {
          "Vertical Candidate List" = false;
          PerScreenDPI = true;
          WheelForPaging = true;
          Font = ''
            "Sarasa Mono J ${
              builtins.toString config.programs.alacritty.settings.font.size
            }"'';
          MenuFont = ''
            "Sarasa Mono J ${
              builtins.toString config.programs.alacritty.settings.font.size
            }"'';
          UseInputMethodLangaugeToDisplayText = true;
          Theme = "Adwaita-dark";
        };
        sections = { };
      };
    };
    "fcitx5/profile" = {
      force = true;
      text = lib.generators.toINI { } {
        "Group/0" = {
          Name = "Default";
          "Default Layout" = "de";
          DefaultIM = "mozc";
        };
        "Group/0/Items/0" = {
          Name = "keyboard-de";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "mozc";
          Layout = "";
        };
        "GroupOrder" = { "0" = "Default"; };
      };
    };
  };
}
