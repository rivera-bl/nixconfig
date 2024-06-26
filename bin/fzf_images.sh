#!/bin/sh

FZF_IMAGES_CLIENT="docker"
FZF_IMAGES_TAGS_REGISTRY_DIR=/tmp/.fzf_images_cache
FZF_IMAGES_ENTRIES=("localhost")
COMMAND="sh /home/wim/code/personal/system/home/zsh/scripts/fzf_images"

AWS_REGION="us-east-1" # ! set with tmux setenv outside of the script

_menu(){ 
  REGISTRIES=$(_get_registry)
  FZF_IMAGES_ENTRIES=("${FZF_IMAGES_ENTRIES[@]}" "${REGISTRIES[@]}")
  _entry_selection \
    $(printf "%s\n" "${FZF_IMAGES_ENTRIES[@]}" | \
      fzf-tmux -p \
      --bind 'ctrl-o:execute(sh ~/system/home/zsh/scripts/fzf_images _tmux_layout_setenv "window")+accept' \
      --bind 'ctrl-v:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _tmux_layout_setenv "split")+accept'
    )
}

_entry_selection(){ 
  if [ ! -z "$1" ]; then 
    case $1 in
      "localhost")
        _tmux_action_layout _local ;;
      *)
        _tmux_action_layout _registry $1 ;;
    esac
  fi
}

_tmux_action_layout(){
  TMUX_LAYOUT=$(tmux showenv | grep "^FZF_IMAGES_LAYOUT" | awk -F '=' '{print $2}')
  tmux setenv -u FZF_IMAGES_LAYOUT
  case $TMUX_LAYOUT in
    "")
      tmux select-pane -t 2 && \
      tmux send-keys -t 2 "$COMMAND $1 $2" Enter
      # tmux send-keys -t right C-w;;
      ;;
    "window")
      tmux neww zsh -c "$COMMAND $1 $2"
      ;;
    "split")
      tmux new-window && tmux split-window -h && \
        tmux setw synchronize-panes on && \
        tmux send-keys "clear_screen 2>/dev/null && $COMMAND $1 $2"  Enter
      ;;
  esac
}

_tmux_layout_setenv(){
  tmux setenv FZF_IMAGES_LAYOUT $1 && export $(tmux showenv | grep "^FZF_IMAGES_LAYOUT")
}

#####################
### ENTRIES
#####################

# ! ctrl-r to reload the list
# --bind "!:reload(rm /tmp/.fzf_images_cache/161642046998.dkr.ecr.us-east-1.amazonaws.com && sh ~/system/home/zsh/scripts/fzf_images _tags_registry \$(echo \$FZF_IMAGES_REGISTRY | awk -F '=' '{print \$2}'))"
_registry(){
  tmux setenv FZF_IMAGES_REGISTRY $1 && \
    export $(tmux showenv | grep '^FZF_IMAGES_REGISTRY')
  _tags_registry $1 | fzf \
    --multi \
    --header-lines=1 \
    --prompt "$(awk -F '.' '{print $1}' <<< $FZF_IMAGES_REGISTRY)> " \
      --bind 'enter:execute-silent(sh ~/system/home/zsh/scripts/fzf_images _action_run /{1}:{2})+abort' \
      --bind 'ctrl-p:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _action_pull {1},{2})+abort' \
      --bind 'ctrl-t:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _action_trivy {1},{2})+abort'
}

# --header $'ctrl-d:rm | ctrl-p:push | ctrl-t:trivy\n' \
# --bind 'ctrl-t:change-preview(ls | bat)' \
_local(){
  $FZF_IMAGES_CLIENT images | fzf \
    --multi \
    --height 90% \
    --header-lines=1 \
    --prompt "$(awk -F '_' '{print $1}' <<< ${AWS_PROFILE:=default})> " \
      --bind 'ctrl-space:toggle-preview' \
      --bind 'enter:execute-silent(sh ~/system/home/zsh/scripts/fzf_images _action_run {3})+abort' \
      --bind 'ctrl-d:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _action_rm {3})+abort' \
      --bind 'ctrl-p:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _action_push {1},{2})+abort' \
      --bind 'ctrl-t:execute-multi(sh ~/system/home/zsh/scripts/fzf_images _action_trivy {1},{2})+abort' \
    --preview-window right,hidden,60% \
    --preview 'sh ~/system/home/zsh/scripts/fzf_images _preview_inspect {3} | bat --plain -l json'
}

#####################
### ACTION
#####################

_action_pull(){
  IMAGES=($(awk -F ',' '{print $1}' <<< $@))
  TAGS=($(awk -F ',' '{print $2}' <<< $@))

  for (( i = 0; $i<${#IMAGES[@]}; i++ )); do
    PULLING="${IMAGES[i]}":"${TAGS[i]}"
    echo -e "\nPulling: $FZF_IMAGES_REGISTRY/$PULLING\n"
    $FZF_IMAGES_CLIENT pull $FZF_IMAGES_REGISTRY/$PULLING
  done
  echo -e "\ndone!" && sleep 2s
}

# ! add confirmation
_action_rm(){
  $FZF_IMAGES_CLIENT image rm $@ --force
  echo -e "\ndone!" && sleep 2s
}

# ! tmux send-keys show output of what was pushed
_action_push(){
  IMAGES=($(awk -F ',' '{print $1}' <<< $@))
  TAGS=($(awk -F ',' '{print $2}' <<< $@))
  for (( i = 0; $i<${#IMAGES[@]}; i++ )); do
    PUSHING="${IMAGES[i]}":"${TAGS[i]}"
    echo -e "\nPushing: $PUSHING\n"
    $FZF_IMAGES_CLIENT push $PUSHING
  done
  echo -e "\ndone!" && sleep 2s
}

_action_trivy(){
  DIR=trivy-$(awk -F '_' '{print $1}' <<< ${AWS_PROFILE:=default})-$(date '+%m%d%Y%H%M%S')
  IMAGES=($(awk -F ',' '{print $1}' <<< $@))
  TAGS=($(awk -F ',' '{print $2}' <<< $@))

  mkdir -p $DIR && trivy --version > $DIR/_version.txt
  for (( i = 0; $i<${#IMAGES[@]}; i++ )); do
    SCANNING="${IMAGES[i]}":"${TAGS[i]}"
    echo -e "\nScanning: $FZF_IMAGES_REGISTRY/$SCANNING\n"
    trivy image $FZF_IMAGES_REGISTRY/$SCANNING || trivy image $FZF_IMAGES_REGISTRY$SCANNING | \
      tee $DIR/${SCANNING##*/}.txt
  done
}

_action_run(){
  PORT=$(tmux showenv | grep '^FZF_IMAGES_PORT' | awk -F '=' '{print $2}')
  if [[ -z "$PORT" ]]; then
    COMMAND="run -ti --rm"
  else
    COMMAND="run -ti --rm -p $PORT:$PORT"
  fi
  tmux send-keys "$FZF_IMAGES_CLIENT $COMMAND $FZF_IMAGES_REGISTRY$1" Enter
  tmux setenv -u FZF_IMAGES_PORT
}

#####################
### PREVIEW
#####################

# ! tee save multiple values to array
_preview_inspect(){
  FZF_IMAGES_PREVIEW_LOCAL=$($FZF_IMAGES_CLIENT inspect $1)
  { PORT=$( echo "$FZF_IMAGES_PREVIEW_LOCAL" | tee /dev/fd/3 | \
    jq -r '.[].Config.ExposedPorts | keys[]' | \
    awk -F "/" '{print $1}'); \
  } 3>&1
  tmux setenv FZF_IMAGES_PORT $PORT
}

#####################
### HELPERS
#####################

# ! show size in MB
# ! split PUSHED by date/time
# ! sort based on date/time in descending order
_tags_registry(){
  # if [[ ! -z "$1" ]]; then _auth_registry $1; fi
  _auth_registry $1; 
  mkdir -p $FZF_IMAGES_TAGS_REGISTRY_DIR
  FZF_IMAGES_TAGS_REGISTRY_FILE=$FZF_IMAGES_TAGS_REGISTRY_DIR/$1

  if [[ -f "$FZF_IMAGES_TAGS_REGISTRY_FILE" ]]; then
    cat $FZF_IMAGES_TAGS_REGISTRY_FILE
  else
    FZF_IMAGES_REGISTRY_REPOS=$(aws ecr describe-repositories --region $AWS_REGION | \
      jq -r ".repositories[].repositoryName")
    for repo in ${FZF_IMAGES_REGISTRY_REPOS[@]} ; do
      FZF_IMAGES_REGISTRY_IMAGES+="$(aws ecr describe-images --repository-name $repo --region $AWS_REGION | \
        jq -r '.imageDetails[] | "\(.repositoryName) \(.imageTags[]?) \(.imagePushedAt) \(.imageSizeInBytes)"')\n"
    done
    echo -e "$FZF_IMAGES_REGISTRY_IMAGES" | \
      sort | sed '1i REPOSITORY TAG PUSHED SIZE' | column -t | \
      tee $FZF_IMAGES_TAGS_REGISTRY_FILE
  fi
}

_get_registry(){
  if [[ $FZF_IMAGES_CLIENT == "podman" ]]; then
    AUTH_FILE=~/.config/containers/auth.json
  elif [[ $FZF_IMAGES_CLIENT == "docker" ]]; then
    AUTH_FILE=~/.docker/config.json
  fi
  cat $AUTH_FILE | jq -r '.credHelpers | keys[]'
}

# note: this assumes that theres a profile defined in .aws/credentials 
# in the format [ACCOUNT_*], if null use default
_auth_registry(){
  FZF_IMAGES_REGISTRY_AWS_ACCOUNT=$(echo "$1" | awk -F '.' '{print $1}')
  FZF_IMAGES_REGISTRY_AWS_PROFILE=$(cat ~/.aws/credentials | \
    grep -o -P "(?<=\[)$FZF_IMAGES_REGISTRY_AWS_ACCOUNT.*(?=\])")
  AWS_PROFILE="${FZF_IMAGES_REGISTRY_AWS_PROFILE:=default}"
}

$@
