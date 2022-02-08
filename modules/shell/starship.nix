{ pkgs, config, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      username = {
        show_always = true;
        format = "[$user]($style) on ";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) in ";
      };
      directory = {
        read_only = " ";
        truncation_length = 5;
      };
      aws.symbol = "  ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      memory_usage.symbol = " ";
      nim.symbol = " ";
      nix_shell.symbol = " ";
      package.symbol = " ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      shlvl.symbol = " ";
      swift.symbol = "ﯣ ";
    };
  };
}
