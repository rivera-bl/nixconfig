#!/bin/sh

# WSL2 Debian 11 Bullseye (updated to testing)
# Install from Microsoft App Store

export USERNAME=casper

# # create user
# useradd -u 1001 -m ${USERNAME} -s /bin/bash
# usermod -aG sudo ${USERNAME}
# passwd ${USERNAME}
echo "[boot]
command=
systemd=true

[interop]
appendWindowsPath=true
enabled=true

[network]
generateHosts=true
generateResolvConf=true
hostname=casper

[user]
default=casper" > /etc/wsl.conf
# switch to testing
sed -i 's/bullseye/testing/g' /etc/apt/sources.list
apt update && sudo apt dist-upgrade
apt install -y curl xz-utils openssh-client
# restart wsl and log in as ${USERNAME}
# set ssh
ssh-keygen -f ~/.ssh/github -t ed25519 -a 100
cat ~/.ssh/github.pub | clip.exe
echo "IdentityFile ~/.ssh/github" > ~/.ssh/config
# install nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
. /home/${USERNAME}/.nix-profile/etc/profile.d/nix.sh
nix --version
# download home
nix-shell -p git
git clone git@github.com:rivera-bl/nixconfig.git && cd nixconfig
# home-manager
# for some reason user daemon not running, to fix the missing /run/user/1001 error:
# # sudo mkdir /run/user/1001 && sudo chown ${USERNAME}:${USERNAME} /run/user/1001
nix build --extra-experimental-features "nix-command flakes" --no-link .#homeConfigurations.${USERNAME}.activationPackage
rm ~/.bashrc ~/.profile
"$(nix --extra-experimental-features "nix-command flakes" path-info .#homeConfigurations.${USERNAME}.activationPackage)"/activate
home-manager switch --flake ~/nixconfig/.
# root
sudo chsh -s /home/${USERNAME}/.nix-profile/bin/zsh ${USERNAME}
# restart wsl to check for changes
# nvim
sudo apt-get install build-essential -y
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
nvim --version # 0.9.1 babyy
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
git clone https://github.com/rivera-bl/editor ~/.config/nvim/lua/custom --depth 1
# clones
mkdir clones && cd clones
git clone https://github.com/nixos/nixpkgs --single-branch --branch nixos-unstable nixpkgs
git clone https://github.com/rishavnandi/wsl_dotfiles
# docker
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker ${USERNAME}
# THIS IS IMPORTANT WHEN USING VPN
# gotta assign an specific address so it doesnt overlaps with the VPN DNS servers
echo "{
  "default-address-pools" : [
    {
      "base" : "172.240.0.0/16",
      "size" : 24
    }
  ]
}" > /etc/docker/daemon.json
docker --version # 24.0
docker run hello-world
# sam cli
cd /tmp
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
## work
ssh-keygen -f ~/.ssh/workgitlab -t ed25519 -a 100
cat ~/.ssh/workgitlab.pub | clip.exe
echo "IdentityFile ~/.ssh/workgitlab" > ~/.ssh/config
