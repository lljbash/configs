#!/bin/bash

set -e

export PATH=/opt/nvim-linux64/bin:$PATH

for APP in \
  python \
  curl wget git snap tar unzip gunzip \
  zsh tmux \
  xsel fzf \
  gcc g++ cmake ccache ninja \
  sqlite3 \
  nvim npm cargo; do
  echo -n "Checking $APP... "
  command -v $APP || (echo "not found" && false)
done
