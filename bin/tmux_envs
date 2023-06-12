#!/bin/sh

# echo $(tmux showenv TMUX:EVENT:PANE_FOCUS_OUT:CURRENT_COMMAND | awk -F'=' '{print $2}')
tmux setenv TMUX:EVENT:PANE_FOCUS_OUT:CURRENT_COMMAND $(tmux display-message -p '#{pane_current_command}')
