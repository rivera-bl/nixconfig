# nix
## rebuild
abbr nrs="sudo nixos-rebuild switch --flake ~/code/personal/system/#"
abbr nrh="home-manager switch --flake ~/nixconfig/."
abbr nrv="cd ~/system && nix flake lock --update-input nvim && sudo nixos-rebuild switch --flake ~/system/# && cd -"
## rollback
abbr nkh="home_manager_generation_rollback"
abbr nkn="nixos_generation_rollback"
## containers
abbr xdf="nix_image_prefetch"
abbr xdb="nix_image_build"
## repl
abbr xrp="nix repl '<nixpkgs>'"
abbr xro="nix repl '<nixpkgs/nixos>'"
# kubectl
abbr mi="minikube"
abbr k="kubectl"
abbr kg="kubectl get"
abbr kd="kubectl delete"
abbr ks="kubectl describe"
abbr kl="kubectl logs"
abbr ka="kubectl apply -f"
## ingress
abbr kgi="kubectl get ingress"
abbr ksi="kubectl describe ingress"
## pod
abbr kgp="kubectl get pod"
abbr kx="kubectl exec -ti"
abbr kdp="kubectl delete pod"
abbr ksp="kubectl describe pod"
abbr kt="kubectl run temp -ti --rm --image"
## svc
abbr kgs="kubectl get service"
abbr kds="kubectl delete service"
abbr kss="kubectl describe service"
## deploy
abbr kgd="kubectl get deployment"
abbr ksd="kubectl describe deployment"
abbr krd="kubectl rollout restart deployment"
## context
abbr kn="kubectl config set-context --current --namespace"
## kubectl fzf
abbr kfn="k8_namespace_switch"
abbr kfl="k8_follow_logs"
# helm
abbr h="helm"
abbr hl="helm list"
abbr hfv="helm_get_values"
# container
# abbr docker="podman"
abbr dk="docker"
abbr dkc="docker container"
abbr dki="docker image"
abbr p="podman"
abbr pi="podman images"
abbr pb="podman build"
abbr px="podman exec -it"
abbr pdu="podman rmi $(podman images | grep '^<none>' | awk '{print $3}') --force"
abbr pl="podman load <"
# tmux
abbr t="tmux"
abbr tkk="tmux kill-server"
abbr pop="tmux display-popup -E -h 100% -w 100% -d $(pwd) zsh -ic"
# terraform
abbr tf="terraform"
abbr tfa="terraform apply"
abbr tfd="terraform destroy"
abbr tfi="terraform init"
abbr tfo="terraform output"
abbr tfv="terraform validate"
abbr tfp="terraform plan"
# misc
abbr vil="nvim -c 'LazyGit'"
abbr m="make"
abbr rt="trash-put"
abbr senv="tmux_set_env '"
abbr we="set_aws_profile"
abbr sy="systemctl"
abbr sys="systemctl status"
abbr shr="vi /mnt/c/Users/pablroja/Documents/wsl-share/_copy.txt"
abbr kfcc="sh ~/code/personal/flakes/kfc/kfc.sh config"
# alias bat="bat --style=numbers --color=always -l || bat --style=numbers --color=always"
