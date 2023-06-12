#!/bin/sh

function home_generation_rollback(){
  selection=$(home-manager generations | fzf-tmux -p --border)
  if [ ! -z "$selection" ]; then
    generation=$(echo $selection | awk '{print $7}')
    echo "Rolling back\n$selection\n"
    $generation/activate
  fi
}
home_generation_rollback
