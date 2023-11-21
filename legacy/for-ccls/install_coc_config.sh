#!/usr/bin/env bash

vim_prefix=~/.vim
coc_settings=coc-settings.json
mkdir -p $vim_prefix
cp $coc_settings $vim_prefix/$coc_settings.temp
cd $vim_prefix
home_double_slash=`echo $HOME | sed 's/\//\\\\\//g'`
sed "s/REPLACE_WITH_HOME_CCLS_CACHE/\"$home_double_slash\/.ccls-cache\"/g" $coc_settings.temp > $coc_settings
rm $coc_settings.temp

if [ ! -x "$(command -v ccls)" ]; then
    echo Warning: ccls is required to use ccls LSP
fi
