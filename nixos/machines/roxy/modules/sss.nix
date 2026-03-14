{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.zerotierone.joinNetworks = [
    "12ac4a1e711ec1f6"
  ];

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /media/anime 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /media/movies 192.168.194.0/24(ro,all_squash,no_subtree_check)
    /media/series 192.168.194.0/24(ro,all_squash,no_subtree_check)
  '';

  services.samba = {
    enable = true;
    nsswins = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "sss";
        "netbios name" = "sss";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      anime = {
        browseable = "yes";
        comment = "Anime Share";
        path = "/media/anime";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      movies = {
        browseable = "yes";
        comment = "Movie Share";
        path = "/media/movies";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      series = {
        browseable = "yes";
        comment = "Series Share";
        path = "/media/series";
        "guest ok" = "yes";
        "read only" = "yes";
      };
      consume = {
        browseable = "yes";
        comment = "Paperless Consume";
        path = "/media/paperless/pre_consume";
        "guest ok" = "no";
        "read only" = "no";
      };
    };
  };
}
