let
  autumnal =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp";
  frie_sv =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6";
  users = [ autumnal frie_sv ];

  # tenshi =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDzOCYF/zwDdMrdNpdk7XSqv0a9twseB7DTZ918IWp5G";
  index =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKd6aKgl2xDyW3/yoWYQa+/sFbiRxXfeXZfOY9vEwTLR";
  castle =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyt1iJTNRkpRaSO+wZ8WX4XnAbiPHUc1+s5hNwOGiLr";
  systems = [ index ];
in {
  "adguard.age".publicKeys = [ index ] ++ users;
  "gobot.age".publicKeys = users;
  "lavalink.age".publicKeys = users;
  "nextcloud_adminpass.age".publicKeys = users;
  "nordvpn_private.age".publicKeys = [ index ] ++ users;
  "mullvard_private.age".publicKeys = [ index ] ++ users;
  "ror2.age".publicKeys = users;
  "transmission_auth.age".publicKeys = [ index ] ++ users;
  "wireguard-castle.age".publicKeys = [ castle ] ++ users;
}
