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
  systems = [ tenshi index ];
in {
  "nordvpn_private.age".publicKeys = [ tenshi index ] ++ users;
  "nextcloud_adminpass.age".publicKeys = [ tenshi index ] ++ users;
  "adguard.age".publicKeys = [ tenshi index ] ++ users;
  "transmission_auth.age".publicKeys = [ tenshi index ] ++ users;
  "transmission_exporter.age".publicKeys = [ tenshi index ] ++ users;
  "github_runner.age".publicKeys = [ tenshi index ] ++ users;
  "lavalink.age".publicKeys = [ tenshi index ] ++ users;
}
