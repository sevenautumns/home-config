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
  # home.file.".config/warpd/config".text = ''
  #   grid_keys: KP_7 KP_8 KP_4 KP_5
  #   buttons: 1 2 3
  # '';
}
