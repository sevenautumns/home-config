{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  services.nginx = {
    enable = true;
    additionalModules = with pkgs.nginxModules; [ rtmp ];
    appendConfig = ''
      rtmp {
          server {
              listen 1935;
              chunk_size 4096;
              allow publish 127.0.0.1;
              deny publish all;
              allow play all;
              application live {
                  live on;
                  record off;
              }
          }
      }
    '';
  };

}
