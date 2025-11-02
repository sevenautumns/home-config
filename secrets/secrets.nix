let
  autumnal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2untVWtTCezJeQxl40TJGsnDvDNXBiUxWnpN4oOdrp";
  frie_sv = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXeNbEgdMSjXN7C22LuaEgj9ppT+zhvyAzYKqiCpn/6";
  users = [
    autumnal
    frie_sv
  ];

  roxy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC3RDWALJo/vw6XeXBQ3lvPJCiJpsReQWMq/MPAYYG0l";
  castle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2tYyAHOAZQs2ME6B6aX5iAxxd9I7jqi1UJW/spYXZK";
  vivi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/y3P7h6fiwG95EHTkVFu9rNjr+2J9IIyWlIhFzMPS/";
  systems = [
    roxy
    castle
  ];
in
{
  "niketsu.age".publicKeys = [ roxy ] ++ users;
  "mullvad_coyote.age".publicKeys = [ roxy ] ++ users;
  "mullvad_well.age".publicKeys = [ ] ++ users;
  "transmission_auth.age".publicKeys = [ roxy ] ++ users;
  "one-and-one.age".publicKeys = [ roxy ] ++ users;
  "firefly.age".publicKeys = [ roxy ] ++ users;
  "wireguard-castle.age".publicKeys = [ castle ] ++ users;
  "rclone-mega.age".publicKeys = [ ] ++ users;
  "ppp-1und1-secret.age".publicKeys = [ ] ++ users;
  "paperless-restic-password.age".publicKeys = [ ] ++ users;
  "homepage_dashboard.age".publicKeys = [ roxy ] ++ users;
}
