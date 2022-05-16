#!/bin/bash

timestamp=$(date +%s)
commit_message="automatic sync $timestamp"

# Dotfiles
git_dot_alias="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"
dot_diff=$($git_dot_alias diff --name-only)
dot_diff_staged=$($git_dot_alias diff --name-only --cached)
echo $dot_diff
echo $dot_diff_staged
if [ "$dot_diff" != "" ] || [ "$dot_diff_staged" != "" ]; then
  if [ "$dot_diff" != "" ]; then
    echo $dot_diff | while read line
    do
      $git_dot_alias add $HOME/$line
    done
  fi
  $git_dot_alias commit -m "$commit_message"
fi
$git_dot_alias push

# Password store
pass git push

# Obsidian vault
cd ~/Documents/obsidian
obsidian_diff=$(git diff --name-only)
if [ "$obsidian_diff" != "" ];then
  git add .
  git commit -m "$commit_message"
fi
git push
