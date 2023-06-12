#!/bin/sh

function nixos_generation_rollback(){
  selection=$(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tac | fzf-tmux -p --border)
  if [ ! -z "$selection" ]; then
    generation=$(echo $selection | awk '{print $1}')
    echo "Rolling back\n$selection\n"
    sudo nix-env --switch-generation -p /nix/var/nix/profiles/system $generation
  fi
}
nixos_generation_rollback
