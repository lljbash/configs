#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <fake_home>"
  exit 1
fi

new_home="$1"

declare -a cache=(
  ".cache"
  ".cargo"
  ".ccache"
  ".local"
  ".npm"
  ".nvm"
  ".rustup"
  ".tmux"
  ".zinit"
)

for i in "${cache[@]}"; do
  if [ -L "$HOME/$i" ]; then
    echo "skip symlink $HOME/$i"
    continue
  fi
  if [ ! -d "$HOME/$i" ]; then
    echo "mkdir $HOME/$i"
    mkdir "$HOME/$i"
  fi
  if [ -e "$new_home/$i" ]; then
    echo "delete $new_home/$i"
    rm -rf "${new_home:?}/$i"
  fi
  echo "move $HOME/$i to $new_home/$i and create symlink"
  mv "$HOME/$i" "$new_home/$i"
  ln -s "$new_home/$i" "$HOME/$i"
done
