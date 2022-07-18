#!/bin/bash

# Dotfiles
git_dot_alias="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
$git_dot_alias pull

# Password store
pass git pull

# Obsidian vault
cd ~/Desktop/obsidian
changed_files=$(git diff --name-only)
changed_files_count=$(git diff --name-only | wc -l)
if [[ $changed_files_count == 1 ]]; then
  if [[ changed_files == ".obisidian/workspace" ]]; then
    # reset if only change is workspace file
    git reset --hard
  fi
fi
git pull
