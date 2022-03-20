{ pkgs, config, ... }: {
  age.secrets.github_runner = {
    file = ../../../../secrets/github_runner.age;
    path = "/var/lib/github/token";
  };

  services.github-runner = {
    enable = true;
    name = config.networking.hostName;
    url = "https://github.com/Steav005/home-config";
    tokenFile = "/var/lib/github/token";
  };
}
