# Important environment variables
## define utilities
get_var() {
  eval 'printf "%s\n" "${'"$1"'}"'
}
set_var() {
  eval "$1=\"\$2\""
}
dedup_var() {
  var_name="$1"
  var_value="$(get_var "$var_name")"
  deduped_var="$(perl -e 'print join(":",grep { not $seen{$_}++  } split(/:/, $ARGV[0]))' "$var_value")"
  set_var "$var_name" "$deduped_var"
}
add_to_var() {
  var_name="$1"
  var_value="$(get_var "$var_name")"
  case ":$var_value:" in
  *:"$2":*) ;;
  *)
    if [ "$3" = "after" ]; then
      new_var=$var_value:$2
    else
      new_var=$2:$var_value
    fi
    set_var "$var_name" "$new_var"
    ;;
  esac
}
## munge PATH
dedup_var PATH
add_to_var PATH "/snap/bin" after
add_to_var PATH "$HOME/.cargo/bin"
add_to_var PATH "$HOME/.local/bin"
## munge LD_LIBRARY_PATH
dedup_var LD_LIBRARY_PATH
add_to_var LD_LIBRARY_PATH /usr/local/lib
add_to_var LD_LIBRARY_PATH /usr/local/lib64
# enable 256 color
if [ -n "$TMUX" ]; then
  export TERM="tmux-256color"
else
  export TERM="xterm-256color"
fi
## enable mouse in less
export LESS="--mouse --wheel-lines=3"
## define other useful variables
export C_INCLUDE_PATH=$C_INCLUDE_PATH:/usr/local/include
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH
## undef utilities
unset -f get_var set_var dedup_var add_to_var

# Other configurations
## git editor
export EDITOR=nvim
## proxy server
#export ALL_PROXY=socks5://localhost:1080
## using ccache for cmake
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CMAKE_CUDA_COMPILER_LAUNCHER=ccache
export CMAKE_GENERATOR=Ninja
export CMAKE_EXPORT_COMPILE_COMMANDS=ON
