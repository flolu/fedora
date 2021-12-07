#!/bin/bash

# Upgrade
sudo dnf upgrade -y

# Clear bloatware
sudo dnf remove -y \
  libreoffice* \
  cheese \
  rhythmbox \
  gnome-calculator \
  gnome-calendar \
  gnome-contacts \
  gnome-tour \
  gnome-maps \
  gnome-weather

# Basics
sudo dnf install -y \
  ckb-next \
  dmenu \
  git-remote-gcrypt \
  yarnpkg \
  gnome-tweaks \
  gnome-extensions-app

# YouTube Download
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
yt-dlp -U

# Docker
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager \
  --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io
if ! [ $(getent group docker) ]; then
  sudo groupadd docker
fi
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker

# Terraform
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform

# Pass
sudo dnf install -y \
  pass \
  pass-otp \
  passmenu \
  xclip

# Snap
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap

# Snap apps
sudo snap install code --classic
sudo snap install node --classic
sudo snap install spotify
sudo snap install chromium
sudo snap install obs-studio
sudo snap install android-studio
sudo snap install discord
sudo snap install kubectl --classic
sudo snap alias kubectl k
sudo snap install google-cloud-sdk --classic

# Obsidian
# TODO download and install lates snap from
# https://github.com/obsidianmd/obsidian-releases/releases

# Brave
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser

# FFmpeg
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y ffmpeg

# VeraCrypt
sudo dnf copr enable bgstack15/stackrpms
sudo dnf install veracrypt

# Dotfiles
read -p "Do you want to setup dotfiles? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  git clone --bare https://github.com/flolu/dotfiles $HOME/dotfiles
  git --git-dir=$HOME/dotfiles --work-tree=$HOME checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} rm $HOME/{}
  git --git-dir=$HOME/dotfiles --work-tree=$HOME checkout
  git --git-dir=$HOME/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
fi

# NVIDIA drivers
read -p "Do you want to install NVIDIA drivers? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  dnf install dnf-plugins-core -y
  dnf copr enable t0xic0der/nvidia-auto-installer-for-fedora -y
  dnf install nvautoinstall -y
  sudo nvautoinstall --rpmadd
  sudo nvautoinstall --driver
fi

# Finish
read -p "Restart now? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  reboot
fi