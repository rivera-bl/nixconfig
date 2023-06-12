{pkgs, ...}:{
  # could manage shell with configuration.nix since you can only set it as default shell there
  programs.fish = {
    enable = false;
    functions = {
      fish_greeting = "";

      bangbang =
        "if test \"$argv\" = !!
          eval command sudo $history[1]
        else
          command sudo $argv
        end";

      bang =
        "switch (commandline -t)
          case \"!\"
              commandline -t $history[1]; commandline -f repaint
          case \"*\"
              commandline -i !
        end";

      dollar =
        "switch (commandline -t)
          case \"!\"
              commandline -t \"\"
              commandline -f history-token-search-backward
          case \"*\"
              commandline -i '$'
        end";

      bash_function = 
        "bash -c 'echo \"hola\"'";

     /* function fzf-complete -d 'fzf completion and print selection back to commandline' */
	# As of 2.6, fish's "complete" function does not understand
	# subcommands. Instead, we use the same hack as __fish_complete_subcommand and
	# extract the subcommand manually.
      fzf-complete = 
        "set -l cmd (commandline -co) (commandline -ct)
        switch $cmd[1]
          case env sudo
            for i in (seq 2 (count $cmd))
              switch $cmd[$i]
                case '-*'
                case '*=*'
                case '*'
                  set cmd $cmd[$i..-1]
                  break
              end
            end
        end
        set cmd (string join -- ' ' $cmd)

        set -l complist (complete -C$cmd)
        set -l result
        string join -- \\n $complist | sort | eval (__fzfcmd) -m --select-1 --exit-0 --header '(commandline)' | cut -f1 | while read -l r; set result $result $r; end

        set prefix (string sub -s 1 -l 1 -- (commandline -t))
        for i in (seq (count $result))
          set -l r $result[$i]
          switch $prefix
            case \"'\"
              commandline -t -- (string escape -- $r)
            case '\"'
              if string match '*\"*' -- $r >/dev/null
                commandline -t --  (string escape -- $r)
              else
                commandline -t -- '\"'$r'\"'
              end
            case '~'
              commandline -t -- (string sub -s 2 (string escape -n -- $r))
            case '*'
              commandline -t -- (string escape -n -- $r)
          end
          [ $i -lt (count $result) ]; and commandline -i ' '
        end

        commandline -f repaint";

      /* fzf-kubectl = */ 
      /*   "bash -c */
      /*   command -v fzf >/dev/null 2>&1 && { */ 
      /*   source <(kubectl completion bash | sed 's#\"${requestComp}\" 2>/dev/null#\"${requestComp}\" 2>/dev/null | head -n -1 | fzf  --multi=0 #g') */
      /*   }"; */
        };

    plugins = [
     {
       name = "fish-kubectl-completions";
       src = pkgs.fetchFromGitHub {
         owner = "evanlucas";
         repo = "fish-kubectl-completions";
         rev = "ced676392575d618d8b80b3895cdc3159be3f628";
         sha256 = "sha256-OYiYTW+g71vD9NWOcX1i2/TaQfAg+c2dJZ5ohwWSDCc=";
       };
     }
    ];

    interactiveShellInit = ''
      fish_vi_key_bindings
      bind -M default yy fish_clipboard_copy
      bind -M default Y fish_clipboard_copy
      bind -M default p fish_clipboard_paste
      bind -M insert -k nul accept-autosuggestion # ctrl-SPACE
      bind -M insert ! bang
      bind -M insert '$' dollar
      bind -M insert \cx bash_function
      bind -M insert \t fzf-complete
    '';
    loginShellInit = "";
    shellInit = "";

    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos/system/#";
      nrh = "home-manager switch --flake ~/nixos/home/#nixos";
    };
    shellAliases = {
      # nix-shell = "nix-shell --command 'fish'";
      k = "kubectl";
    };
  };

}
