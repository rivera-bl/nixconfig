#!/bin/sh

# Fix rezising when changing session panes, current_window_name and last_window_name comparison not workin
# fix hooks get correct one
TMUX_AUTOZOOM_NVIM=$(tmux showenv TMUX_AUTOZOOM_NVIM | awk -F '=' '{print $2}')
current_window_name=$(tmux list-panes -F "#{session_name}:#{window_name}" | head -n 1)
last_window_name=$(tail /tmp/tmux_last_pane -n 2 | head -n1 | cut -f1 -d".")

if [ "$TMUX_AUTOZOOM_NVIM" = "1" ] && [ "$current_window_name" = "$last_window_name" ]; then
  cmd=$(tmux display-message -p "#{pane_current_command}")
  [ $cmd != "nvim" ] || tmux resize-pane -Z
else
  exit 0
fi
