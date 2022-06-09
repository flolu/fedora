#!/bin/bash

if [[ $USER == "root" ]]
then
  echo "Please execute ./setup without sudo!"
  exit 1
fi

timestamp=$(date +%s)
commit_message="automatic sync $timestamp"

# Dotfiles
git_dot_alias="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
dot_diff=$($git_dot_alias diff --name-only)
dot_diff_staged=$($git_dot_alias diff --name-only --cached)
if [ "$dot_diff" != "" ] || [ "$dot_diff_staged" != "" ]; then
  if [ "$dot_diff" != "" ]; then
    for file in $dot_diff
    do
      echo "Round"
      echo $HOME/$file
      $git_dot_alias add $HOME/$file
    done
  fi
  $git_dot_alias commit -m "$commit_message"
fi
$git_dot_alias push origin master

# Password store
pass git push

# TODO copy password-store to USB

# Obsidian vault
cd ~/Desktop/obsidian
obsidian_diff=$(git diff --name-only)
if [ "$obsidian_diff" != "" ];then
  git add .
  git commit -m "$commit_message"
fi
git push
