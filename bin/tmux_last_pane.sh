#!/bin/sh

# this.script > sets tmux env TMUX_PANE_LAST to last session:window_name.pane_id
# tmux.conf   > runs this.script on every pane and session focus-in, using tmux hooks
# tmux.conf   > bind-key to switch-client/select-window -t $TMUX_PANE_LAST

file="/tmp/tmux_last_pane"

tmux run-shell -C 'setenv TMUX_PANE "#{pane_id}"'

pane=$(tmux showenv TMUX_PANE | cut -d= -f2)
session_window_pane_id=$(tmux list-panes -F "#{session_name}:#{window_name}.#{pane_id}" | grep $pane)

# save current session:window.pane to file
echo "$session_window_pane_id" >> $file

# get number of line before last
last_pane_line=$(echo $(($(wc -l < $file)-1)))

# if session:window of last_pane_line NOT equals session:window of session_window_pane_id
if [ "$(sed -n ${last_pane_line}p $file | cut -d. -f1)" != "$(echo $session_window_pane_id | cut -d. -f1)" ]; then
  # save last pane id to tmux env
  last_pane_id=$(sed -n ${last_pane_line}p $file)
  tmux setenv TMUX_PANE_LAST $last_pane_id
fi
