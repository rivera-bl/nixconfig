#!/bin/sh

function aws_instance_types(){
  CACHE_FILE=/tmp/.aws_instance_types_cache
  if [[ -s "$CACHE_FILE" ]]; then
    SELECTION=$(cat $CACHE_FILE | fzf-tmux -p --border --header-lines=1)
  else
    # jq values separated by space | sort by cpu/ram | sed add headers | column | fzf
    SELECTION=$(aws ec2 describe-instance-types --region us-east-1 | \
      jq -r '.InstanceTypes[] | "\(.InstanceType) \(.VCpuInfo.DefaultVCpus) \(.MemoryInfo.SizeInMiB)"' | \
      sort -k2,2n -k3,3n | \
      sed '1i TYPE CPU RAM' | column -t | tee $CACHE_FILE | \
      fzf --header-lines=1)
  fi

  if [ ! -z "$SELECTION" ]; then
    tmux setb "$SELECTION"
  fi
}

aws_instance_types
