let
  autumnal =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp";
  frie_sv =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6";
  users = [ autumnal frie_sv ];

  tenshi =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDzOCYF/zwDdMrdNpdk7XSqv0a9twseB7DTZ918IWp5G";
  index =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd6aKgl2xDyW3/yoWYQa+/sFbiRxXfeXZfOY9vEwTLR";
  castle =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyt1iJTNRkpRaSO+wZ8WX4XnAbiPHUc1+s5hNwOGiLr";
  systems = [ tenshi index ];
in {
  "adguard.age".publicKeys = [ index ] ++ users;
  "gobot.age".publicKeys = [ tenshi ] ++ users;
  "lavalink.age".publicKeys = [ tenshi ] ++ users;
  "nextcloud_adminpass.age".publicKeys = [ tenshi ] ++ users;
  "nordvpn_private.age".publicKeys = [ tenshi index ] ++ users;
  "ror2.age".publicKeys = [ tenshi ] ++ users;
  "transmission_auth.age".publicKeys = [ index ] ++ users;
  "wireguard-castle.age".publicKeys = [ castle ] ++ users;
}
