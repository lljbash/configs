get_g3dir() {
  local TRY_G3DIR="${$(pwd -P)%/google3*}"
  if [[ -d "${TRY_G3DIR}/.hg" ]]; then
    G3DIR=${TRY_G3DIR}/google3
  else
    unset G3DIR
  fi
}

# Call get_g3dir at shell start and after every cd
get_g3dir
chpwd_functions=(${chpwd_functions[@]} "get_g3dir")

expand_g3dir() {
  if [[ -v G3DIR ]]; then
    LBUFFER="${LBUFFER//\/\//${G3DIR}/}"
    zle redisplay
  fi
}

zle -N expand_g3dir

# Defined shortcut keys: <C-\>//
bindkey -M emacs '^\' expand_g3dir
bindkey -M vicmd '^\' expand_g3dir
bindkey -M viins '^\' expand_g3dir
