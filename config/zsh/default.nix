{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    enableCompletion = true; # environment.pathsToLink = [ "/share/zsh" ];
    enableSyntaxHighlighting = true;

    dirHashes = {
    };

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      ignorePatterns = [
        "clear"
        "vi"
        "nvim -S"
        "set_aws_profile"
      ];

    # saves as string and it has to be integer
      save = 100000;
      size = 100000;
    };

    #######################################
    # variables/files in order of execution
    #######################################
    # .zshenv
    envExtra = "setopt no_global_rcs";

    # .zprofile
    profileExtra = "
      if [ -e \${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . \${HOME}/.nix-profile/etc/profile.d/nix.sh; fi
      ";

    # .zshrc before completion init
    initExtraBeforeCompInit = "";
    completionInit= "
      autoload -U compinit
      compinit
      zmodload zsh/complist
      _comp_options+=(globdots)		# Include hidden files.

      # https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh
      # source $HOME/.config/_tmuxinator
      ";

    # .zshcr
    localVariables = {
    };

    initExtraFirst = "";
    initExtra = "
      ${builtins.readFile ./alias.zsh}
      ${builtins.readFile ./functions}
      export PATH=\"/usr/local/opt/grep/libexec/gnubin:$HOME/.local/bin:$PATH\"
      zplug load
      stty -ixon # unbind ctrl-s and ctrl-q
      bindkey '\\0' forward-char # CTRL-SPACE accept-autosuggestion
      # bindkey '^I' forward-char # TAB accept-autosuggestion
      export _ZL_ADD_ONCE=1;
      export FZF_COMPLETION_TRIGGER=','
      # dont show direnv env change when enter dir
      export DIRENV_LOG_FORMAT=

      # aws autocomplete
      autoload bashcompinit && bashcompinit
      # which aws_completer
      complete -C '/run/current-system/sw/bin/aws_completer' aws

      # # npm allow global install
      # export PATH=~/.npm-packages/bin:$PATH
      # export NODE_PATH=~/.npm-packages/lib/node_modules

      # Gotta add this here because for some reason HM is not updating the
      # variable with fzf.nix
      export FZF_CTRL_R_OPTS=\"--history-size=100000\"

      # export HISTSIZE=100000
      # export SAVEHIST=100000
      # export HISTORY_IGNORE='(clear|vi|nvim -S|set_aws_profile)'

      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt BANG_HIST
      # setopt HIST_REDUCE_BLANKS
      # setopt EXTENDED_HISTORY
      # setopt appendhistory
      setopt share_history
      # setopt inc_append_history

      # dont save failed commands to history
      zshaddhistory() { whence \${\${(z)1}[1]} >| /dev/null || return 1 }

      # # zsh-vi-mode
      # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      # ZVM_CURSOR_STYLE_ENABLED=false
      # ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
      # # otherwise it overrides fzf C-r
      # zvm_after_init_commands+=('[ -f /home/nixos/system/home/zsh/.fzf.zsh ] && source /home/nixos/system/home/zsh/.fzf.zsh')

      # fzf-tab-completion
      source \${HOME}/nixconfig/config/fzf/fzf-tab-completion/zsh/fzf-zsh-completion.sh
      zstyle ':completion:*' fzf-search-display true # allow match on description
      zstyle ':completion::*:lsd::*' fzf-completion-opts --preview='eval bat --color=always {1}'
      zstyle ':completion::*:terraform::*' fzf-completion-opts --height=60% --preview='eval terraform {1} -help | bat --color=always '
      export FZF_COMPLETION_AUTO_COMMON_PREFIX=true

      # terraform completion
      complete -C ${pkgs.terraform}/bin/terraform terraform

      # kubectl completion
      source <(kubectl completion zsh)
      # make completion work with kubecolor
      # compdef kubecolor=kubectl
    ";

    # .zlogin
    loginExtra = "";

    # .zlogout
    logoutExtra = "";

    # ?before or after zsh
    sessionVariables = {};

    shellAliases = {};
    shellGlobalAliases = {};

    zplug = {
      # zplugHome = "~/.config/zsh/.zplug/"; # has to be of type path
      enable = true;
      plugins = [
        { name = "chitoku-k/fzf-zsh-completions"; }
        { name = "olets/zsh-abbr"; }
        # { name = "jeffreytse/zsh-vi-mode"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
      ];
    };

    plugins = [
    {
       # will source zsh-autosuggestions.plugin.zsh
       name = "zsh-autosuggestions";
       src = pkgs.fetchFromGitHub {
         owner = "zsh-users";
         repo = "zsh-autosuggestions";
         rev = "v0.4.0";
         sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
         };
       }
    ];

    # various ohmyzsh options
  };
}
