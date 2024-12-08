{ pkgs, config, ... }: {

  # FIXME remove when #360592 resolves
  # https://github.com/NixOS/nixpkgs/issues/360592
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  services.sonarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.bazarr = {
    enable = true;
    user = "autumnal";
    group = "media";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  age.secrets = {
    homepage_dashboard = {
      file = ../../../../secrets/homepage_dashboard.age;
    };
  };

  services.homepage-dashboard = {
    enable = true;
    environmentFile = config.age.secrets.homepage_dashboard.path;
    widgets = [
      {
        resources = {
          label = "System";
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        resources = {
          label = "Storage";
          disk = "/media";
        };
      }
    ];
    services = [
      {
        Monitors = [
          {
            Sonarr = {
              icon = "sonarr.svg";
              href = "http://192.168.178.2:8989";
              description = "Shows";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
              };
            };
          }
          {
            Radarr = {
              icon = "radarr.svg";
              href = "http://192.168.178.2:7878";
              description = "Movies";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
              };
            };
          }
          {
            Bazarr = {
              icon = "bazarr.svg";
              href = "http://192.168.178.2:6767";
              description = "";
              widget = {
                type = "bazarr";
                url = "http://localhost:6767";
                key = "{{HOMEPAGE_VAR_BAZARR_API_KEY}}";
              };
            };
          }
          {
            Prowlarr = {
              icon = "prowlarr.svg";
              href = "http://192.168.178.2:9696";
              description = "";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
              };
            };
          }
        ];
      }
    ];
  };
}
