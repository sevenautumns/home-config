{
  config,
  flakeRoot,
  ...
}:
{
  age.secrets = {
    firefly = {
      file = flakeRoot + "/secrets/firefly.age";
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
  };

  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = config.age.secrets.firefly.path;
    };
  };
}
