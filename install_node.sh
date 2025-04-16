#!/bin/bash

set -e

export PROFILE=/dev/null
for F in $(declare -F | grep "declare -F nvm" | cut -f 3 -d " "); do unset -f "$F"; done
for V in $(declare -x | grep "declare -x NVM" | cut -f 3 -d " " | cut -f 1 -d "="); do unset -v "$V"; done

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts
nvm alias default lts/*
