#Enable Fig prompt information
FIG_PROMPT_NO_HYPERLINKS=1
source ~/fig_prompt

# Template Arguments:
#   FIG_PROMPT_MODIFIED: Replaced with $modified
#   FIG_PROMPT_ADDED: Replaced with $added
#   FIG_PROMPT_DELETED: Replaced with $deleted
#   FIG_PROMPT_UNKNOWN: Replaced with $unknown
#   FIG_PROMPT_UNEXPORTED: Replaced with $unexported
#   FIG_PROMPT_OBSOLETE: Replaced with $obsolete
#   FIG_PROMPT_CL: Replaced with $cl
#   FIG_PROMPT_DESCRIPTION: Replaced with $description
#   FIG_PROMPT_CHANGENAME: Replaced with $changename
#   FIG_PROMPT_HAS_SHELVE: Replaced with $has_shelve
function get_fig_prompt_template() {
  echo -n '%F{yellow}FIG_PROMPT_MODIFIED %F{green}FIG_PROMPT_ADDED'
  echo -n ' %F{red}FIG_PROMPT_DELETED %F{magenta}FIG_PROMPT_UNKNOWN'
  echo -n ' %F{magenta}FIG_PROMPT_HAS_SHELVE %F{white}FIG_PROMPT_DESCRIPTION '
  echo -n ' %F{blue}FIG_PROMPT_UNEXPORTED %F{red}FIG_PROMPT_OBSOLETE'
  echo -n ' %F{white}FIG_PROMPT_CL'
}

# Custom p10k segment for fig
# will not appear unless the directory is a citc client
function prompt_fig() {
    local fig_prompt
    fig_prompt="$(get_fig_prompt)"
    p10k segment -f 208 -c $fig_prompt -t $fig_prompt
}
