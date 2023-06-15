#
## Aliases to not expand as abbr
#

# for getting history and vi keys
# NIX
alias nix-shell="nix-shell --command zsh"
# nix-shell -p python3Packages.pip  python3Packages.boto3

# delete nix profile, needed for mac when it fuck up builds randomly
alias v="nvim -S"
alias vi="nvim"
alias zf="z -I ."
# alias kubectl="kubecolor"
# alias rm="echo 'Better use trash-cli.'; false"
alias rm="rm -v"
alias sq="sh ~/code/github/simpleql/simpleql"

# z
alias ch="z -I -t ."  # fzf, by date
alias cz="z -I -c ."  # fzf, only child dirs
alias cb="z -b"       # back to parent

# ls
alias ls="lsd -l"
alias ll="lsd -al"
alias lt="lsd --tree"
alias ld="lsd -d --tree"

#MAIN
alias g="LazyGit"
alias ts="tmuxinator start"
alias ki="sudo killall"
alias grep="grep --color"
alias py="python -c 'import code; import readline; readline.parse_and_bind(\"set editing-mode vi\"); code.interact(local=locals())'"
alias duh="du -h --max-depth=1 | sort -hr"

#GIT
alias gto="cd $(git rev-parse --show-toplevel)"
alias gdi="sh ~/code/personal/system/home/zsh/scripts/fzf_git_dirs"
alias ga="git add $@"
alias gaa="git add ."
alias gc="git commit -m $1"
alias gs="git status"
alias gp="git pull"
alias gpp="git push"
# alias gl="git log --color --decorate --oneline --graph | tac"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --branches --remotes"

# PACKER
alias pk="packer"
alias pkb="packer build"

# VAGRANT
alias vg="vagrant"
alias vgu="vagrant up && vagrant ssh"
alias vgd="vagrant destroy"

# TMUX
alias t="tmux"
alias tm="tmuxinator"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new -t"

#MANPAGES
#Simple Prompt Escapes from zsh manpage
alias zpes="man zshmisc | sed -n '2030,$'p | less"
#VCS Info Module information from zsh manpage
alias zvcs="man zshcontrib | sed -n '800,$'p | less"
#Complist Module from zsh manpage
alias zlst="man zshmodules | sed -n '251,$'p | less"
#Completion System from zsh manpage
alias zcom="man zshcompsys"
