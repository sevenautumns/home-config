{ pkgs, config, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      #right_format = "\${custom.nix-shell-info}";
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
      localip = {
        ssh_only = false;
        disabled = true;
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
      # Print packages of shell if we are in nix-shell
      custom.nix-shell-info = {
        command =
          "${pkgs.any-nix-shell}/bin/nix-shell-info | sed 's/x1B[[0-9;]{1,}[A-Za-z]//g'";
        when = "test 0 -ne $(${pkgs.any-nix-shell}/bin/nix-shell-info | wc -w)";
        format = "with \\[[$output]($style)\\] ";
        shell = [ "${pkgs.bash}/bin/bash" ];
      };
    };
  };
}
