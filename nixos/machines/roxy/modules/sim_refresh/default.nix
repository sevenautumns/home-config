{
  config,
  pkgs,
  flakeRoot,
  ...
}:
let
  group = "sim_refresh";
  user = "sim_refresh";
in
{
  users.users.${user} = {
    inherit group;
    createHome = false;
    isSystemUser = true;
  };
  users.groups.${group} = { };

  systemd.services.sim_refresh = {
    path = with pkgs; [
      unstable.playwright-driver.browsers
      (pkgs.unstable.python3.withPackages (python-pkgs: [
        python-pkgs.playwright
      ]))
    ];
    wantedBy = [ "multi-user.target" ];
    script = "python ${./refresh.py}";
    serviceConfig = {
      EnvironmentFile = config.age.secrets.one-and-one.path;
      Restart = "always";
      User = user;
    };
    environment = {
      PLAYWRIGHT_BROWSERS_PATH = pkgs.unstable.playwright-driver.browsers;
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    };
  };

  age.secrets.one-and-one = {
    file = flakeRoot + "/secrets/one-and-one.age";
    owner = user;
  };
}
