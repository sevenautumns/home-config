{ pkgs, config, ... }: {
  programs.nushell = {
    enable = false;
    configFile.text = ''
      let-env config = {
        rm: {
          always_trash: true
        }
        
        completions: {
          algorithm: fuzzy
        }
        
        history: {
          sync_on_enter: true
          file_format: "sqlite"
          history_isolation: false
        }
        show_banner: false
        
        hooks: {
          pre_prompt: [{ ||
            let direnv = (direnv export json | from json)
            let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
            $direnv | load-env
          }]
        }

        keybindings: [
          {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
              until: [
                { send: menu name: completion_menu }
                { send: menunext }
              ]
            }
          }
          {
            name: pazi
            modifier: CONTROL
            keycode: Char_y
            mode: [emacs vi_normal vi_insert]
            event: {
              send: executehostcommand,
              cmd: "try { cd (pazi jump --pipe='sk --layout=reverse') }"
            }
          }
        ]
      }
    '';
  };
}
