{ pkgs, config, ... }: {
  programs.nushell = {
    # enable = false;
    # configFile.text = ''
    #   let-env config = {
    #     rm_always_trash: true
    #     completion_algorithm: fuzzy
    #     show_banner: false
        
    #     hooks : {
    #       pre_prompt: [{
    #         code: "
    #           let direnv = (direnv export json | from json)
    #           let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
    #           $direnv | load-env
    #         "
    #       }]
    #     }
    #   }

    #   alias cat = bat
    # '';
  };
}
