{ pkgs, config, lib, inputs, ... }: {
  # nixpkgs.config.packageOverrides = super: {
  #   keynav = (pkgs.stable.keynav.overrideAttrs (old: {
  #     postPatch = ''
  #       substituteInPlace keynav.c \
  #         --replace \
  #           'cairo_set_source_rgb(canvas_cairo, 1, 1, 1);' \
  #           'cairo_set_source_rgb(canvas_cairo, 0.95, 0.95, 0.8);'
  #     '' + old.postPatch;
  #   }));
  # };
  services.keynav.enable = true;
  home.file.".keynavrc".text = ''
    clear
    ctrl+KP_5 start,grid 3x3
    Escape end

    ctrl+KP_7 move-left,move-up
    ctrl+KP_8 move-up
    ctrl+KP_9 move-right,move-up
    ctrl+KP_4 move-left
    ctrl+KP_6 move-right
    ctrl+KP_1 move-left,move-down
    ctrl+KP_2 move-down
    ctrl+KP_3 move-right,move-down

    space warp,click 1,end
    KP_Enter warp,click 1,end
    KP_0 click 1,end

    KP_7 cell-select 1x1
    KP_8 cell-select 2x1
    KP_9 cell-select 3x1
    KP_4 cell-select 1x2
    KP_5 cell-select 2x2
    KP_6 cell-select 3x2
    KP_1 cell-select 1x3
    KP_2 cell-select 2x3
    KP_3 cell-select 3x3
  '';
}
