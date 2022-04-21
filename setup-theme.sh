#!/bin/bash

# Colloid gtk theme for linux
sudo dnf install -y sassc
git clone https://github.com/vinceliuice/Colloid-gtk-theme
cd ./Colloid-gtk-theme
git checkout 519c2c9d2aa55122d079d10d2beddc4dea2cca0e
./install.sh --dest ~/.themes
cd ..

# Kora icon theme
git clone https://github.com/bikass/kora
cd ./kora
git checkout af092d2e99b4fb8f83f37bf8ddc5acae43bb36dc
cp -R ./kora ~/.icons/
cd ..

# Bibata Cursor
sudo dnf copr enable -y peterwu/rendezvous
sudo dnf install -y bibata-cursor-themes

# Wallpaper
mkdir ~/Pictures/Wallpapers
curl https://images.wallpapersden.com/image/download/poly-lakeside-minimal_amxqa26UmZqaraWkpJRobWllrWdma2U.jpg > ~/Pictures/Wallpapers/poly-lakeside.jpg
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/Wallpapers/poly-lakeside.jpg"
