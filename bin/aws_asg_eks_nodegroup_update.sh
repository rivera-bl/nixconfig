#!/bin/sh

# # update size of first asg of first nodegroup of eks cluster
#
CLUSTER_NAME=$1
# list nodegroups of $EKS and select
# TODO get $nodegroup via user-input, use defaultnodegroups[0] by default
nodeGroup=$(aws eks list-nodegroups \
  --cluster-name ${CLUSTER_NAME} \
  --query "nodegroups[0]" \
  --output text)

# # TODO update to use autoscaling, instead of eks
# # generalize the usage of this script
# # in the end we can get the name of the asg via input with regex
# # because the cluster-name is on the name of the sage

# get asg of nodegrp selected
nodeGroupJson=$(aws eks describe-nodegroup \
  --cluster-name \
  $CLUSTER_NAME \
  --nodegroup-name $nodeGroup)

autoscalingGroupName=$(echo $nodeGroupJson | jq -r ".nodegroup.resources.autoScalingGroups[0].name")
minSize=$(echo $nodeGroupJson | jq -r ".nodegroup.scalingConfig.minSize")
desiredSize=$(echo $nodeGroupJson | jq -r ".nodegroup.scalingConfig.desiredSize")
maxSize=$(echo $nodeGroupJson | jq -r ".nodegroup.scalingConfig.maxSize")

# list desired-capacity number option between min/max capacity of asg 
# create a list of numbers between min max
# output the list to fzf
# set desired-capacity with selection
numbers=""
for (( i=0; i<=$maxSize; i++ )); do numbers+="$i\n"; done
# echo -e $numbers

selection=$(echo -e $numbers | tr " " "\n" | \
  fzf --prompt "  min: ${minSize} | curr: ${desiredSize} | max ${maxSize}")

if (( selection < minSize )); then minSize=$selection; fi

# TODO add prompt to confirm the changes
aws autoscaling \
  update-auto-scaling-group\
  --auto-scaling-group-name $autoscalingGroupName \
  --min-size $minSize \
  --desired-capacity $selection

# TODO command to check status of cluster
# TODO when previous command gets certain value, 
# # execute the nodes back to previous min,curr,max
