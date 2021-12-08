#!/bin/bash

# Upgrade
sudo dnf upgrade -y
echo "Upgrade successfull"

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
echo "Cleared bloatware"

# Basics
sudo dnf install -y \
  ckb-next \
  dmenu \
  git-remote-gcrypt \
  yarnpkg \
  gnome-tweaks \
  gnome-extensions-app
echo "Installed basics"

# YouTube Download
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
sudo cp yt-dlp.conf /etc/yt-dlp.conf
sudo yt-dlp -U
echo "Installed yt-dlp"

# Docker
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager \
  --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
if ! [ $(getent group docker) ]; then
  sudo groupadd docker
fi
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl enable docker
sudo systemctl start docker
echo "Installed Docker"

# Terraform
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform
echo "Terraform"

# Pass
sudo dnf install -y \
  pass \
  pass-otp \
  passmenu \
  xclip
echo "Pass"

# Snap
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap
echo "Installed snap"

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
echo "Installed snap apps"

# Obsidian
# TODO download and install lates snap from
# https://github.com/obsidianmd/obsidian-releases/releases

# Brave
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
echo "Installed Brave"

# FFmpeg
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y ffmpeg
echo "Installed FFmpeg"

# VeraCrypt
sudo dnf copr enable -y bgstack15/stackrpms
sudo dnf install -y veracrypt
echo "Installed VeraCrypt"

# Tor
sudo dnf install -y tor privoxy
sudo service tor start
sudo systemctl enable tor
sudo cp privoxy.config /etc/privoxy/config
sudo service privoxy start
sudo systemctl enable privoxy
gsettings set org.gnome.system.proxy mode 'manual' # 'none' to turn off
gsettings set org.gnome.system.proxy.http host 'localhost'
gsettings set org.gnome.system.proxy.http port '8118'
gsettings set org.gnome.system.proxy.https host 'localhost'
gsettings set org.gnome.system.proxy.https port '8118'
gsettings set org.gnome.system.proxy.socks host 'localhost'
gsettings set org.gnome.system.proxy.socks port '9050'
echo "Installed Tor"

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
echo "Dot files were successfully set up"

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