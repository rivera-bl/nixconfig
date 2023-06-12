#!/bin/sh

# WSL2 openSUSE Tumbleweed 20230608
# Install from Microsoft App Store

USERNAME=casper

sudo zypper ref -b && sudo zypper dup # update
sudo zypper search -s podman # check the package version, beautiful
# set user
passwd # set root passwd
useradd ${USERNAME} && passwd ${USERNAME} # add our user
# install nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
# set ssh
ssh-keygen -f ~/.ssh/github -t ed25519 -a 100
cat ~/.ssh/github.pub | clip.exe # add .pub key to github settins
echo "IdentityFile ~/.ssh/github" > ~/.ssh/config
# download config
nix-shell -p git
git clone git@github.com:rivera-bl/nixconfig.git && cd nixconfig
# home-manager
nix build --extra-experimental-features "nix-command flakes" --no-link .#homeConfigurations.${USERNAME}.activationPackage
"$(nix --extra-experimental-features "nix-command flakes" path-info .#homeConfigurations.${USERNAME}.activationPackage)"/activate
home-manager switch --impure --flake ~/nixconfig/.
# root
chsh -s /home/${USERNAME}/.nix-profile/bin/zsh ${USERNAME}
# installs
# # docker
echo "[boot]
command=
systemd=false

[interop]
appendWindowsPath=true
enabled=true

[network]
generateHosts=true
generateResolvConf=true
hostname=casper

[user]
default=root" > /etc/wsl.conf
sudo zypper in docker
sudo systemctl enable --now docker
sudo usermod -aG docker ${USERNAME}
newgrp docker
docker run hello-world
# restart wsl
# # sam
cd /tmp
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
# # sam test
sam --version
sam init
sam build --use-container # or use a nix-shell via default.nix
sam local invoke
# # systemd fix
chown ${USERNAME}:${USERNAME} /run/user/1001
