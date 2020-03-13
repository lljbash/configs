#!/usr/bin/env sh

sudo add-apt-repository "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main"
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -

sudo apt-get update
sudo apt-get install clang clangd

