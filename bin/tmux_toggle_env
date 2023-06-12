#!/bin/sh

# TOGGLE
# TODO fix if tmux doesnt have the var set
# could just create it on start of tmux with a 1 value
# TODO create a validation for this env that if there is only one pane on the window, it will exit
val=$(tmux showenv $1 | awk -F'=' '{print $2}')

# if [ -z "$val" ]; then
#   export val="1"
# fi

if [[ $val == "1" ]]; then
 tmux setenv $1 0
 break
elif [[ $val == "0" ]]; then
 tmux setenv $1 1
fi

# automatically resize if toggled on nvim pane
if [[ $1 = "TMUX_AUTOZOOM_NVIM" ]]; then
  pane_current_command=$(tmux display-message -p '#{pane_current_command}')
  if  [[ $pane_current_command = "nvim" ]]; then
    tmux resize-pane -Z
  fi
fi
