#!/bin/sh
#

ROLE="Call aws sts get caller identity here"

# send command to all panes on current session, just using it to refresh with C-w
# TODO send it only to shell panes, not vim
_tmux_send_keys_all_panes_ () {
  tmux list-panes -s -F '#{session_name}:#{window_index}.#{pane_index}' \
                  | xargs -I PANE tmux send-keys -t PANE "$@"
}

# switch k8 cluster
function k8_cluster_switch(){
  selection=$(kubectl config get-contexts | fzf-tmux -p --border --header-lines=1)
  if [ ! -z "$selection" ]; then
    CLUSTER=$(echo $selection | awk '{print $1}')
    ACCOUNT=$(echo $CLUSTER | awk -F ":" '{print $5}')
    tmux setenv AWS_PROFILE "${ACCOUNT}_${ROLE}" && tmux_set_env 'export $(tmux showenv | grep "^AWS_PROFILE")'
    tmux setenv CLUSTER "${CLUSTER}" && tmux_set_env 'export $(tmux showenv | grep "^CLUSTER")'
    tmux run-shell -b 'kubectl config use-context $CLUSTER > /dev/null'
    sleep 0.1s && _tmux_send_keys_all_panes_  C-w
  fi
}

k8_cluster_switch

# zle -N k8_cluster_switch
# bindkey -r '^p'
# bindkey '^p' k8_cluster_switch
