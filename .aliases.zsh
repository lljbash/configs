# common
alias l="ls -lhF"
alias la="ls -alhF"
alias tmux="tmux -2"
alias javac="javac -J-Dfile.encoding=utf8"
alias grep="grep --color=auto"

# vim
alias vi=vim
export EDITOR=vi

# cmake
alias cconf="cmake -H. -Bbuild"
alias cconfr="cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release"
alias cconfd="cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Debug"
alias creconf="rm -rf build; cmake -H. -Bbuild"
alias creconfr="rm -rf build; cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release"
alias creconfd="rm -rf build; cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Debug"
alias cbuild="cmake --build build --"
alias crebuild="cmake --build build --clean-first --"
alias cclean="cmake --build build --target clean"

# extension
alias -s js=vi
alias -s c=vi
alias -s h=vi
alias -s cc=vi
alias -s java=vi
alias -s txt=vi
alias -s gz='tar -xzvf'
alias -s tar='tar -xvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

