{ pkgs, config, host, lib, inputs, ... }: {

  xsession = {
    enable = true;
    windowManager = {
      leftwm = {
        enable = false;
        package = inputs.leftwm.packages."x86_64-linux".leftwm;
        settings = {
          modkey = "Mod4";
          disable_tile_drag = false;
          layout_mode = "Tag";
          keybind = [
            # Remove if sxhkd works
            {
              command = "Execute";
              value = "alacritty";
              modifier = [ "modkey" "Shift" ];
              key = "Return";
            }
            {
              command = "IncreaseMainWidth";
              modifier = [ "modkey" "Control" ];
              value = "5";
              key = "Up";
            }
            {
              command = "DecreaseMainWidth";
              modifier = [ "modkey" "Control" ];
              value = "5";
              key = "Down";
            }
            {
              command = "NextLayout";
              modifier = [ "modkey" "Control" ];
              key = "Right";
            }
            {
              command = "PreviousLayout";
              modifier = [ "modkey" "Control" ];
              key = "Left";
            }
            {
              command = "CloseWindow";
              modifier = [ "modkey" ];
              key = "c";
            }
            {
              command = "ToggleFloating";
              modifier = [ "modkey" "Shift" ];
              key = "space";
            }
            {
              command = "FocusWindowUp";
              modifier = [ "modkey" ];
              key = "Up";
            }
            {
              command = "FocusWindowDown";
              modifier = [ "modkey" ];
              key = "Down";
            }
          ];
        };
      };
    };
  };
}
