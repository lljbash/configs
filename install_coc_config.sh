#!/usr/bin/env bash

cp ./coc-settings.json ~/.vim/coc-settings.json

if [ ! -x "$(command -v ccls)" ]; then
    echo Warning: ccls is required to use ccls LSP
fi

