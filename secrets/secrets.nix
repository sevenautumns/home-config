let
  autumnal =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp";
  frie_sv =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6";
  users = [ autumnal frie_sv neesama ];

  index =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd6aKgl2xDyW3/yoWYQa+/sFbiRxXfeXZfOY9vEwTLR";
  index_new =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3RDWALJo/vw6XeXBQ3lvPJCiJpsReQWMq/MPAYYG0l";
  castle =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2tYyAHOAZQs2ME6B6aX5iAxxd9I7jqi1UJW/spYXZK";
  neesama =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/y3P7h6fiwG95EHTkVFu9rNjr+2J9IIyWlIhFzMPS/";
  systems = [ index castle ];
in
{
  "niketsu.age".publicKeys = [ index index_new ] ++ users;
  "mullvad_coyote.age".publicKeys = [ index index_new ] ++ users;
  "mullvad_well.age".publicKeys = [ index_new ] ++ users;
  "transmission_auth.age".publicKeys = [ index index_new ] ++ users;
  "wireguard-castle.age".publicKeys = [ castle ] ++ users;
  "rclone-mega.age".publicKeys = [ index_new ] ++ users;
  "ppp-1und1-secret.age".publicKeys = [ index_new ] ++ users;
  "paperless-restic-password.age".publicKeys = [ index_new ] ++ users;
}
