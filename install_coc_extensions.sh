#!/usr/bin/env bash

if [ ! -x "$(command -v node)" ]; then
    echo Error: nodejs is required to use coc
    exit 1
fi

mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

npm install coc-lists --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-dictionary --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-word --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-snippets --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-highlight --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-calc --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-yank --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-clangd --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

if [ ! -x "$(command -v clangd)" ]; then
    echo Warning: clangd is required to use coc-clangd
fi

