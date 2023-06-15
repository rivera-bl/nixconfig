#!/bin/sh

function fzf_git_dirs() {
  repos=$(find $HOME/code $HOME/notes -type d -name .git \
          ! -path  "*/.local/*" \
          ! -path "*/.zplug/*" \
          ! -path "*/.cache/*" | \
          cut -f1 -d "." | \
          cut -f4- -d "/")
  list="STATUS,REPOSITORY\n"

  # get status of repo
  while read line; do
    cd $HOME/$line
    if [[ $(git status --porcelain | wc -l) -gt 0  ]]; then  
      git_status="+"
    else   
      git_status=" "
    fi
    list+="$git_status,$line\n"
  done <<< "$repos" # quotes are important

  # columns to fzf
  # printf behaves more consistently
  selected=$(printf "$list" | column -t -s , | fzf-tmux -p --border --header-lines=1)
  # open repo with nvim lazygit
  [[ -n "$selected" ]] && { tmux neww zsh -c \
    "cd $HOME/$selected || cd $HOME/$(awk '{print $2}' <<< $selected) && \
    nvim -c 'LazyGit'"; \
    exit 1; }
}

fzf_git_dirs
