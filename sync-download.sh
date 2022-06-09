#!/bin/bash

# Dotfiles
git_dot_alias="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
$git_dot_alias pull

# Password store
pass git pull

# Obsidian vault
cd ~/Desktop/obsidian
git pull
