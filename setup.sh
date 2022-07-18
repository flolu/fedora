#!/bin/bash

# Applications directory
APPLICATIONS_DIR=$HOME/Applications
mkdir -p $APPLICATIONS_DIR

if [[ $USER == "root" ]]
then
  echo "Please execute ./setup without sudo!"
  exit 1
fi

# Upgrade
sudo dnf upgrade -y
echo "Upgrade successfull"

# Configure git
git config --global credential.helper store
git config --global user.name "flolu"
git config --global user.email "loflude@gmail.com"
git config --global commit.gpgsign true
git config --global user.signingkey 2BF2E9B3FB1972D8

# Basics
sudo dnf install -y \
  ckb-next \
  dmenu \
  git-remote-gcrypt \
  gnome-tweaks \
  gnome-extensions-app \
  webp-pixbuf-loader \
  xdotool
sudo dnf install -y python3-pip
echo "Installed basics"

# YouTube Download
python3 -m pip install -U yt-dlp
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
sudo dnf install -y docker-compose
echo "Installed Docker"

# Terraform
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform
echo "Terraform"

# Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install --lts
sudo dnf install -y npm
# npm install -g npm
echo "Node.js"

# Pass
sudo dnf install -y \
  pass \
  pass-otp \
  xclip
sudo cp passmenu /usr/bin/
echo "Installed Pass"

# Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Snap
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap
echo "Installed snap"

# Snap apps
sudo snap install code --classic
sudo snap install spotify
sudo snap install chromium
sudo snap install obs-studio
sudo snap install kubectl --classic
sudo snap alias kubectl k
sudo snap install google-cloud-sdk --classic
sudo snap install blender --classic
sudo snap install telegram-desktop
echo "Installed snap apps"

# Session Messenger
gh release download --repo oxen-io/session-desktop --pattern 'session-desktop-linux-x86_64-*.rpm' --dir $HOME/Downloads/
sudo dnf install -y $HOME/Downloads/session-desktop-linux-x86_64-*.rpm
rm $HOME/Downloads/session-desktop-linux-x86_64-*.rpm

# Obsidian
gh release download --repo obsidianmd/obsidian-releases --pattern 'obsidian_*_amd64.snap' --dir $HOME/Downloads/
OBSIDIAN_SNAP_FILE=$(ls $HOME/Downloads/obsidian_*_amd64.snap | head -1 2>&1)
sudo snap install --dangerous $OBSIDIAN_SNAP_FILE
rm $OBSIDIAN_SNAP_FILE
OBSIDIAN_VAULT_DIR=~/Desktop/obsidian
OBSIDIAN_PLUGINS_DIR=$OBSIDIAN_VAULT_DIR/.obsidian/plugins
git clone gcrypt::https://github.com/flolu/obsidian $OBSIDIAN_VAULT_DIR
mkdir -p $OBSIDIAN_PLUGINS_DIR
gh release download --repo flolu/obsidian-scroll-speed --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/scroll-speed
gh release download --repo cristianvasquez/obsidian-prettify --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/markdown-prettifier
gh release download --repo avr/obsidian-reading-time --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/obsidian-reading-time
gh release download --repo phibr0/obsidian-emoji-shortcodes --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/emoji-shortcodes
gh release download --repo chrisgrieser/obsidian-smarter-md-hotkeys --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/obsidian-smarter-md-hotkeys
gh release download --repo liamcain/obsidian-calendar-plugin --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/calendar
gh release download --repo argenos/nldates-obsidian --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/nldates-obsidian
gh release download --repo uphy/obsidian-reminder --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/obsidian-reminder-plugin
gh release download --repo phibr0/cycle-through-panes --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/cycle-through-panes
gh release download --repo deathau/sliding-panes-obsidian --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/sliding-panes-obsidian
gh release download --repo denolehov/obsidian-url-into-selection --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/url-into-selection
gh release download --repo vslinko/obsidian-outliner --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/obsidian-outliner
gh release download --repo obsidian-tasks-group/obsidian-tasks --pattern '*' --dir $OBSIDIAN_PLUGINS_DIR/obsidian-tasks-plugin
# TODO Spell checking with locally run Docker instance
# https://github.com/obsidianmd/obsidian-releases/releases

# Brave
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
echo "Installed Brave"

# Ledger Live
LEDGER_LIVE_APPIMAGE=$APPLICATIONS_DIR/ledger-live-desktop-linux-x86_64.AppImage
wget -o $LEDGER_LIVE_APPIMAGE https://download.live.ledger.com/latest/linux
chmod a+x $
alias ledger-live-desktop="./$LEDGER_LIVE_APPIMAGE"

# Ledger Live
mkdir -p $HOME/Applications
LEDGER_LIVE_APPIMAGE=$HOME/Applications/ledger-live-desktop-linux-x86_64.AppImage
wget -O $LEDGER_LIVE_APPIMAGE https://download.live.ledger.com/latest/linux
chmod a+x $LEDGER_LIVE_APPIMAGE
# https://support.ledger.com/hc/en-us/articles/115005165269-Fix-connection-issues?support=true
wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | sudo bash

LEDGER_LIVE_DESKTOP_FILE=$HOME/.local/share/applications/ledger-live.desktop
touch $LEDGER_LIVE_DESKTOP_FILE
cat > $LEDGER_LIVE_DESKTOP_FILE << EOF
[Desktop Entry]
Type=Application
Name=Ledger Live
Exec="$LEDGER_LIVE_APPIMAGE"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Monero GUI
flatpak install -y flathub org.getmonero.Monero
sudo flatpak override org.getmonero.Monero --filesystem=$HOME

# Monero Mining
git clone https://github.com/hinto-janaiyo/monero-bash &&
cd monero-bash &&
./monero-bash
# TODO xmrig.json "max-cpu-usage": 75,
# TODO https://github.com/xmrig/xmrig-cuda
# Build deps
# https://xmrig.com/docs/miner/build/fedora
# sudo dnf install -y git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
# git clone https://github.com/xmrig/xmrig-cuda
# cd xmrig-cuda
# mkdir build && cd build
# # cmake .. -DCUDA_LIB=/usr/lib64/libcuda.so -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
# cmake .. -DCUDA_LIB=/usr/lib64/libcuda.so
# make -j$(nproc)

# LaTeX
# https://fedoraproject.org/wiki/Features/TeXLive#Benefit_to_Fedora
sudo dnf install -y texlive-scheme-basic

# GitHub CLI
sudo dnf install -y gh
if [[ "$(gh auth status 2>&1)" =~ "You are not logged into any GitHub hosts" ]]
then
  gh auth login --git-protocol https --hostname github.com --web
fi


# FFmpeg
# sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf install -y ffmpeg
# echo "Installed FFmpeg"

# Raw image thumbnails
sudo cp ./gdk-pixbuf-thumbnailer.thumbnailer /usr/share/thumbnailers
rm -rf ~/.cache/thumbnails/*

# VeraCrypt
# sudo dnf copr enable -y bgstack15/stackrpms
# sudo dnf install -y veracrypt
# echo "Installed VeraCrypt"

# Tor
# sudo dnf install -y tor privoxy
# sudo service tor start
# sudo systemctl enable tor
# sudo cp privoxy.config /etc/privoxy/config
# sudo service privoxy start
# sudo systemctl enable privoxy
# gsettings set org.gnome.system.proxy mode 'manual' # 'none' to turn off
# gsettings set org.gnome.system.proxy.http host 'localhost'
# gsettings set org.gnome.system.proxy.http port '8118'
# gsettings set org.gnome.system.proxy.https host 'localhost'
# gsettings set org.gnome.system.proxy.https port '8118'
# gsettings set org.gnome.system.proxy.socks host 'localhost'
# gsettings set org.gnome.system.proxy.socks port '9050'
# echo "Installed Tor"

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
# https://rpmfusion.org/Howto/NVIDIA
sudo dnf install -y akmod-nvidia
sudo dnf install -y xorg-x11-drv-nvidia-cuda
sudo sed -i -e 's/#WaylandEnable=false.*/WaylandEnable=false/' /etc/gdm/custom.conf

# Finish
read -p "Restart now? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  reboot
fi
