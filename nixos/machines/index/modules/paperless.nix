{ pkgs, config, inputs, lib, ... }: {
  services.paperless = {
    enable = true;
    user = "autumnal";
    package = pkgs.unstable.paperless-ngx;
    address = "10.4.0.0";
    port = 28981;
    dataDir = "/media/paperless";
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = builtins.toJSON {
        continue_on_soft_render_error = true;
        invalidate_digital_signatures = true;
      };
    };
  };
}
