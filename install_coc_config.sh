#!/usr/bin/env bash

cp ./coc-settings.json ~/.vim/coc-settings.json
home_double_slash=`echo $HOME | sed 's/\//\\\\\//g'`
sed -i "s/REPLACE_WITH_HOME_CCLS_CACHE/\"$home_double_slash\/.ccls-cache\"/g" ~/.vim/coc-settings.json

if [ ! -x "$(command -v ccls)" ]; then
    echo Warning: ccls is required to use ccls LSP
fi

