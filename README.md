# Nix home tools

if not being able to use `.exe` programs:

````bash
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
exit
wsl --shutdown
wsl -d ${distro}
echo "hola" | clip.exe
````

Editor is other repository.

## Casper

*DISCLAIMER: Podman is a pain in the ass. Gotta run containers/pods with `--privileged` in order to do SYSCALLS like `ping`. Using it just because I couldn't run minikube with docker in WSL. If needing to use a container client just go with docker because of the compatibility with other tools, like `sam cli` or any other random github project.*

Docker systemd works in WSL with VPN when docker network doesn't overlaps VPN DNS server. This with all distros.

````bash
# check the docker network created by docker
# modify it if necessary on /etc/docker/daemon.json
route -n
````

### Nixos

Docker and podman (root) configured via NixOS, and minikube via HM.

````bash
minikube start --kubernetes-version='v1.26.1' --driver=podman --container-runtime=cri-o
kubectl run tmp -ti --rm --privileged=true --image=nginx:alpine -- sh
````

### Debian and openSUSE

Docker and podman (rootless) configured via Apt, and minikube via HM.

````bash
sudo apt install -y podman
# minikube not working yet
minikube config set rootless true
minikube start --kubernetes-version='v1.26.1' --driver=podman --container-runtime=cri-o
kubectl run tmp -ti --rm --privileged=true --image=nginx:alpine -- sh
````

[1]: https://gist.github.com/adisbladis/187204cb772800489ee3dac4acdd9947
