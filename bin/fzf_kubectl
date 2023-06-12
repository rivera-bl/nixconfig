#!/bin/sh

AWS_REGION="us-east-1"
REGISTRY="$(awk -F '_' '{print $1}' <<< $AWS_PROFILE).dkr.ecr.$AWS_REGION.amazonaws.com"


# TODO add action secret_decode
# TODO complete formating of custom-columns
# binding to C - for moving preview down
#####################
### ENTRY
#####################

# TODO customize like fzf_images
function _menu(){
  vals=("pod" "service" "event" "pvc" "secret" "irsa")
  selection=$(printf "%s\n" "${vals[@]}" \
    | fzf-tmux \
      --header "$(tmux showenv | grep KUBECONFIG | awk -F'/' '{print $5}')" \
      -p --border)
  case $selection in
  "pod")
     func="_entry_pod"
     ;;
  "service")
     func="_entry_svc"
     ;;
  "event")
     func="_entry_event"
     ;;
  "pvc")
     func="_entry_pvc"
     ;;
  "secret")
     func="_entry_secret"
     ;;
  "irsa")
     func="_entry_irsa"
     ;;
  esac
  if [ ! -z "$selection" ]; then
    export func=$func
    # tmux split-window -h
    tmux neww zsh -c "source ~/code/personal/system/home/zsh/scripts/fzf_kubectl; $func"
    unset func
  fi
}

sys_path="/home/wim/code/personal/system"
function _entry_irsa(){
  UNPRIVILEGED="kubectl get serviceaccount"
  FZF_DEFAULT_COMMAND="kubectl get serviceaccount -A 2>/dev/null || $UNPRIVILEGED" \
  fzf \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --height 60% \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
    --header $'╱ Enter (show policy attached to role) ╱\n\n' \
      --bind 'enter:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _irsa_policies {1},{2})+abort' \
      --bind 'ctrl-e:execute(kubectl edit serviceaccount --namespace {1} {2})+abort' \
      --bind 'ctrl-space:toggle-preview' \
    --preview-window right,60% \
    --preview 'kubectl get serviceaccount --namespace {1} {2} -o yaml | bat --wrap auto --style=numbers --color=always -l yaml' "$@"
}

# TODO fix custom-columns port,age
function _entry_svc(){
  UNPRIVILEGED="kubectl get svc \
    -o=custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,PORT(S):.spec.ports[].port'"
  FZF_DEFAULT_COMMAND="kubectl get svc -A || $UNPRIVILEGED" \
  fzf \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --height 99% \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
    --header $'╱ Enter (port forward) ╱\n\n' \
      --bind 'enter:execute(kubectl port-forward -n {1} svc/{2} :)+abort' \
      --bind 'ctrl-space:toggle-preview' \
    --preview-window right,hidden,50% \
    --preview 'kubectl get svc --namespace {1} {2} -o yaml | bat -l yaml' "$@"
}

# TODO fix custom-columns data,age
function _entry_secret(){
  UNPRIVILEGED="kubectl get secrets \
    -o=custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,TYPE:.type'"
  FZF_DEFAULT_COMMAND="kubectl get secrets -A 2>/dev/null || $UNPRIVILEGED" \
  fzf \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --height 60% \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
    --header $'╱ Enter (base64 -d) ╱\n\n' \
      --bind 'enter:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _secret_decode {1},{2})+abort' \
      --bind 'ctrl-space:toggle-preview' \
    --preview-window right,hidden,50% \
    --preview 'kubectl get secret --namespace {1} {2} -o json | bat --wrap auto --style=numbers --color=always -l json' "$@"
}

# TODO fix custom-columns volume,capacity,access,age
# VOLUME:.spec.resources.requests.storage,\
# ACCESS MODES:.spec.accessModes[],\
function _entry_pvc() {
  UNPRIVILEGED="kubectl get pvc \
    -o=custom-columns='\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
STATUS:.status.phase,\
STORAGECLASS:spec.storageClassName'"
  FZF_DEFAULT_COMMAND="kubectl get pvc -A 2>/dev/null || $UNPRIVILEGED" \
  fzf \
    --height 80% \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
    --header $'| Enter (mount on temporary pod pvc-inspector) |\n\n' \
		  --bind 'enter:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pvc_inspect {1},{2})+abort' "$@" \
      --bind 'ctrl-space:toggle-preview' \
    --preview-window right,hidden,50% \
    --preview 'kubectl describe pvc --namespace {1} {2} | bat -l yaml' "$@" 
}

function _entry_event(){
  _event_command | fzf \
    --height 99% \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
      --bind 'ctrl-space:toggle-preview' \
    --preview-window right,hidden,50% \
    --preview 'kubectl describe -n {1} {5} | bat -l yaml'
}

function _entry_pod() {
  UNPRIVILEGED="kubectl get pod \
    -o=custom-columns='\
NAMESPACE:.metadata.namespace,\
NAME:.metadata.name,\
READY:.status.containerStatuses[].ready,\
STATUS:.status.containerStatuses[].state.*.reason,\
RESTARTS:.status.containerStatuses[].restartCount'"
  FZF_DEFAULT_COMMAND="
    kubectl get pod --all-namespaces 2>/dev/null || \
    $UNPRIVILEGED" \
  fzf \
    --multi \
    --height 99% \
    --header-lines=1 \
    --info=inline \
    --layout=reverse \
    --prompt "$(kubectl config current-context | sed 's/-cluster$//')> " \
      --bind 'enter:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pod_exec {1},{2})+abort' \
      --bind 'ctrl-f:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pod_logs {1} {2})+abort' \
      --bind 'ctrl-r:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pod_restart_deploy {1} {2})+reload(kubectl get pod -A)' \
      --bind 'ctrl-b:execute(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pod_debug {1},{2})+clear-query+reload(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _tags_registry)' \
      --bind 'ctrl-d:execute-multi(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _pod_delete {1} {2})+reload(kubectl get pod -A)' \
        --bind 'ctrl-v:change-preview-window(down,80%|)+change-preview(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _preview_events {1},{2})' \
        --bind 'ctrl-s:change-preview-window(right|)+change-preview(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _preview_describe pod,{1},{2})' \
        --bind 'ctrl-l:change-preview-window(down,80%|)+change-preview(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _preview_logs {1},{2})' \
          --bind '?:preview(sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _help_pod)' \
          --bind '!:reload(kubectl get pod -A)' \
          --bind 'ctrl-space:toggle-preview' \
    --preview-window down,60% \
    --preview 'sh ~/code/personal/system/home/zsh/scripts/fzf_kubectl _preview_events {1},{2}'
}

#####################
### ACTION
#####################

function _irsa_policies(){
  # get role_arn from serviceaccount json
  IFS=',' read -r -a array <<< "$@"
  sa=$(kubectl get sa -n ${array[0]} ${array[1]}  -o json)
  role_arn=$(echo $sa | \
    jq -r '.metadata.annotations."eks.amazonaws.com/role-arn"')
  # get name from role_arn
  role_name=$(awk -F '/' '{print $2}' <<< $role_arn)
  policy_names=$(aws iam list-attached-role-policies --role-name $role_name | \
    jq -r '.AttachedPolicies[].PolicyArn')

  policies="$sa,\n\n"
  while read line; do
    version=$(aws iam get-policy --policy-arn $line | jq -r '.Policy.DefaultVersionId') 
    policies+="\"$line\": $(aws iam get-policy-version --policy-arn $line --version-id $version),\n\n"
  done <<< "$policy_names"

  echo "$policies" | nvim -R -c "set syntax=json"
}

# TODO fix this not working with multiple keys? or not working in mac
# try with template:
# kubectl get secrets ecom-security-svc-secrets --template={{.data.API_KEY}} | base64 -d  
function _secret_decode(){
  IFS=',' read -r -a array <<< "$@"
  secret=$(kubectl get secret -n ${array[0]} ${array[1]} -o json | \
    jq ".data")
  secret_keys=$(jq -r "keys | @sh" <<< $secret | tr -d \' | tr ' ' '\n')

  while read line; do
    secret_decoded+="$line: |\n $(jq -r .\"$line\" <<< $secret | base64 -d)\n"
  done <<< "$secret_keys"

  printf "secret: ${array[1]}\nnamespace: ${array[0]}\n\n$secret_decoded" | \
    nvim -c "set syntax=yaml" -c "setlocal buftype=nofile"
}

function _pvc_inspect(){
  IFS=',' read -r -a array <<< "$@"
  cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Pod
    metadata:
      name: pvc-inspector
      namespace: ${array[0]} 
    spec:
      securityContext:
        fsGroup: 2000 
      containers:
      - image: busybox
        name: pvc-inspector
        command: ["tail"]
        args: ["-f", "/dev/null"]
        volumeMounts:
        - mountPath: /pvc
          name: pvc-mount
          readOnly: true
      volumes:
      - name: pvc-mount
        persistentVolumeClaim:
          claimName: ${array[1]} 
EOF
  sleep 5s && kubectl exec -ti pvc-inspector -n ${array[0]} -- sh -c "cd /pvc && /bin/sh"
  kubectl delete pod pvc-inspector -n ${array[0]}  --force
}

# TODO fix errors related to execute-multi
# --bind 'ctrl-d:execute-multi(kubectl delete pod --namespace {1} {2} --force)+reload(kubectl get pod --all-namespaces)+abort' \
function _pod_delete(){
  kubectl delete pod -n $@ --force
  sleep 10s
}

# NOTE using debug action here to reuse the --bind enter:
function _pod_exec(){
  IFS=',' read -r -a array <<< "$@"
  export $(tmux showenv | grep '^FZF_KUBECTL_DEBUG')
  if [[ $FZF_KUBECTL_DEBUG ]]; then
    export $(tmux show-environment | grep "^FZF_KUBECTL_DEBUG_NS") 
    export $(tmux show-environment | grep "^FZF_KUBECTL_DEBUG_POD") 
    IMAGE=$REGISTRY/${array[0]}:${array[1]} 
    kubectl debug -ti -n $FZF_KUBECTL_DEBUG_NS $FZF_KUBECTL_DEBUG_POD  --image=$IMAGE --share-processes --copy-to=debug-$FZF_KUBECTL_DEBUG_POD -- bash
    kubectl delete pod debug-$FZF_KUBECTL_DEBUG_POD -n $FZF_KUBECTL_DEBUG_NS --force
  else
    kubectl exec -it --namespace ${array[0]} ${array[1]} -- bash || kubectl exec -it --namespace ${array[0]} ${array[1]} -- sh
  fi
  tmux setenv -u FZF_KUBECTL_DEBUG
}

function _pod_restart_deploy(){
  tmux send-keys "$2"
  kubectl rollout restart deployment --namespace $1 $(echo $2 | rev | cut -f3- -d '-' | rev)
}

function _pod_logs(){
  DEPLOYMENT_NAME=$(kubectl get pod --namespace $@ -o json | jq -r ".metadata.ownerReferences[].name")
  tmux setenv FZF_KUBECTL_STERN $DEPLOYMENT_NAME
  tmux send-keys "stern $(tmux showenv | grep '^FZF_KUBECTL_STERN'| awk -F '=' '{print $2}') -n $1" Enter
}

# TODO change prompt to 'Enter: select image to debug {pod} -n {namespace}'
function _pod_debug(){
  IFS=',' read -r -a array <<< "$@"
  tmux setenv FZF_KUBECTL_DEBUG true
  tmux setenv FZF_KUBECTL_DEBUG_NS "${array[0]}"
  tmux setenv FZF_KUBECTL_DEBUG_POD "${array[1]}"
}

#####################
### PREVIEW
#####################

# TODO fix formatting of column items
# awk '{\$4=\"\"; \$5 = \"\t\" \$5; \$1 = \"\t\" \$1; \$2 = \"\t\" \$2; \$3 = \"\t\" \$3; print \$0;}'
function _preview_events(){
  IFS=',' read -r -a array <<< "$@"
  kubectl get event --namespace "${array[0]}"  --field-selector involvedObject.name="${array[1]}"  | \
    sed -e "1s/LAST SEEN/SEEN/" | \
    sed "1{H;1h;\$!d;\${g;q;};};\$G" | \
    tac | bat --plain --color=always -l fstab
}

function _preview_describe(){
  IFS=',' read -r -a array <<< "$@"
  kubectl describe "${array[0]}" "${array[2]}" --namespace "${array[1]}" | \
    bat --color=always -l yaml
}

function _preview_logs(){
  IFS=',' read -r -a array <<< "$@"
  kubectl logs --all-containers --tail=10000 --namespace ${array[0]} ${array[1]} | \
    tac
}

#####################
### HELPERS
#####################

function _event_command(){
  UNPRIVILEGED="CMA0564-k8sqacl02"
  CURRENT_CONTEXT=$(kubectl config current-context | sed 's/-cluster$//')
  if [[ $CURRENT_CONTEXT == $UNPRIVILEGED ]]; then
    kubectl get event --sort-by=.metadata.creationTimestamp | sort -k1 -n
  else
    kubectl get event -A --sort-by=.metadata.creationTimestamp | sort -k2 -n
  fi
}

# TODO make this easier to write
function _help_pod(){
  echo '
    { "actions": 
      { 
        "ctrl-f": "logs -f", 
        "ctrl-r": "rollout restart", 
        "ctrl-d": "delete pod",
        "ctrl-b": "debug" 
      }, 
    "preview": 
      { 
        "ctrl-v": "get event", 
        "ctrl-s": "describe pod", 
        "ctrl-l": "logs -f"
      },
    "!": "reload"
    }' | jq '.' | \
    bat --plain --color=always -l json
}

# TODO should reuse this with fzf_images
_tags_registry(){
  FZF_IMAGES_TAGS_REGISTRY_DIR=/tmp/.fzf_images_cache
  FZF_IMAGES_TAGS_REGISTRY_FILE=$FZF_IMAGES_TAGS_REGISTRY_DIR/$REGISTRY
  mkdir -p $FZF_IMAGES_TAGS_REGISTRY_DIR

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

$@
