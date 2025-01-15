#!/bin/bash

set -e

for APP in \
  curl wget git snap tar unzip gunzip \
  zsh tmux \
  xsel fzf \
  gcc g++ cmake ccache ninja \
  sqlite3; do
  echo -n "Checking $APP... "
  command -v $APP || (echo "not found" && false)
done
