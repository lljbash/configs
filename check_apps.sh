#!/bin/bash

set -e

for APP in \
  python \
  curl wget git snap tar unzip gunzip \
  zsh tmux \
  xsel fzf gh \
  gcc g++ cmake ccache ninja \
  sqlite3 \
  nvim npm cargo; do
  echo -n "Checking $APP... "
  command -v $APP || (echo "not found" && false)
done
