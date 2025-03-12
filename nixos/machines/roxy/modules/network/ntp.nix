{ pkgs, ... }:
{
  services.chrony = {
    enable = true;
    extraConfig = ''
      allow 192.168.1
      allow 192.168.178
      allow 172.16
    '';
  };
}
