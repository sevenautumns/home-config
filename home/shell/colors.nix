{
  pkgs,
  config,
  lib,
  ...
}:
let
  theme = rec {
    # https://github.com/helix-editor/helix/blob/16525349dbb2b72064e1cfb5cc3164dc236fd367/runtime/themes/autumn.toml
    black = "#212121"; # Cursorline
    gray0 = "#262626"; # Default Background
    gray1 = "#2b2b2b"; # Ruler
    gray2 = "#323232"; # Lighter Background (Used for status bars, line number and folding marks)
    gray3 = "#505050"; # Selection Background
    gray4 = "#7c7c7c"; # Comments, Invisibles, Line Highlighting
    gray5 = "#a8a8a8"; # Dark Foreground (Used for status bars)
    gray6 = "#c0c0c0"; # Light Foreground (Not often used)
    gray7 = "#e8e8e8"; # Light Background (Not often used)
    white = "#F3F2CC"; # Default Foreground, Caret, Delimiters, Operators
    white2 = "#F3F2CC"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    white3 = "#F3F2CC"; # Classes, Markup Bold, Search Text Background
    turquoise = "#86c1b9"; # Support, Regular Expressions, Escape Characters
    turquoise2 = "#72a59e"; # URL
    green = "#99be70"; # Strings, Inherited Class, Markup Code, Diff Inserted
    brown = "#cfba8b"; # Member variables, Quotes
    yellow1 = "#FAD566"; # Functions, Methods, Attribute IDs, Headings
    yellow2 = "#ffff9f"; # Debug, Info
    red = "#F05E48"; # Keywords, Storage, Selector, Diff Changed

    background = gray0;
    background-light1 = gray2;
    background-light2 = gray7;

    foreground = white;
    foreground-dark = gray5;
    foreground-light = gray6;

    text = foreground;
    hint = red;
    primary = brown;
  };
in
{
  options = with lib; {
    theme = mapAttrs (
      name: value:
      mkOption {
        type = types.str;
        default = value;
      }
    ) theme;
    theme-non_hex = mapAttrs (
      name: value:
      mkOption {
        type = types.str;
        default = builtins.replaceStrings [ "#" ] [ "" ] value;
      }
    ) theme;
  };
}
