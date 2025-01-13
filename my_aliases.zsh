# mkdir + cd
mcd () {
  mkdir -p "$@" && cd "${@:$#}" || return 1
}

# vim -> nvim
vim () {
  if (( $+commands[nvim] )); then
    /usr/bin/env nvim "$@"
  else
    /usr/bin/env vim "$@"
  fi
}
alias vi=vim

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
