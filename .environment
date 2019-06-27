export PATH=$PATH
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH
export LIBRARY_PATH=$LIBRARY_PATH
export CPATH=$CPATH:/usr/local/include

# Deduplicate path variables
get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'

}
set_var () {
    eval "$1=\"\$2\""

}
dedup_pathvar () {
    pathvar_name="$1"
    pathvar_value="$(get_var "$pathvar_name")"
    deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++  } split(/:/, $ARGV[0]))' "$pathvar_value")"
    set_var "$pathvar_name" "$deduped_path"

}
dedup_pathvar PATH
dedup_pathvar LD_LIBRARY_PATH
dedup_pathvar LIBRARY_PATH
dedup_pathvar CPATH

