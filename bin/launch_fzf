#!/bin/sh

sys_path="${HOME}/code/personal/system"
scripts_path="${sys_path}/home/zsh/scripts"
vals=("k8s cmd" \
      "k8s context" \
      "aws sso" \
      "aws cluster" \
      "aws instance" \
      "img ecr" \
      "img local" \
      "git status" \
      "nix nixpkgs" \
      "nix rollback home" \
      "nix rollback nixos" \
      "tmux projects" \
      "notes")

# TODO dynamic preview based on cursor position
function _menu(){
  selection=$(printf "%s\n" "${vals[@]}" \
              | column -t -s' ' \
              | fzf-tmux -p --border)
              # | fzf-tmux -p --border --preview-window wrap:right,80% --preview 'kfc -h ')
              # | fzf-tmux -p --border --preview-window wrap:right,80% --preview 'fws --help')

  [ -z "$selection" ] && exit 0;
  case $(echo "$selection" | tr -d '[:space:]') in
  "k8scmd")
     sh -c "${scripts_path}/fzf_kubectl _menu"
     ;;
  "k8scontext")
     /home/wim/code/personal/flakes/kfc/kfc.sh -c
     ;;
  "awscluster")
     sh -c "kfc -r"
     ;;
  "awssso")
     sh -c "tmux display-popup -b rounded -E 'fws --login'"
     ;;
  "notes")
     sh -c "sh ${scripts_path}/tmux_notes"
     ;;
  "awsinstance")
     sh -c "sh ${scripts_path}/fzf_instance_types"
     ;;
  "imgecr")
     tmux neww zsh -c "fim --ecr"
     ;;
  "imglocal")
     tmux neww zsh -c "fim --local"
     ;;
  "gitstatus")
     sh -c "sh ${scripts_path}/fzf_git_dirs | true"
     ;;
  "nixrollbackhome")
     sh -c "sh ${scripts_path}/fzf_nix_rollback_home"
     ;;
  "nixrollbacknixos")
     sh -c "sh ${scripts_path}/fzf_nix_rollback_nixos"
     ;;
  "nixnixpkgs")
     sh -c "tmux neww zsh -c 'cd ${HOME}/nixpkgs && nvim -S'"
     ;;
  "tmuxprojects")
     sh -c "ls ${sys_path}/home/tmuxinator | column -t -s' ' | sed 's/\\..*//' | fzf-tmux --border -p --preview 'bat ${sys_path}/home/tmuxinator/{1}.yml' --bind 'enter:execute-silent(tmuxinator start {1})+abort' | true"
     ;;
  esac
}

_menu
