{ pkgs, config, inputs, lib, ... }:
let
  jaeger = fetchTarball {
    url =
      "https://github.com/jaegertracing/jaeger/releases/download/v1.35.1/jaeger-1.35.1-linux-amd64.tar.gz";
    sha256 = "sha256:10v10w016lvks6jai8l30bd0da79c6x6lqkg27rq0acb27xznrsg";
  };
in {

  #systemd.services.jaeger = {
  #  enable = true;
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    #User = "jaeger";
  #    ExecStart =
  #      "${jaeger}/jaeger-all-in-one --collector.zipkin.host-port=:9411";
  #    #Restart = "always";
  #    #RestartSec = 2;
  #    #WorkingDirectory = "/var/lib/jaeger";
  #  };
  #};

}
