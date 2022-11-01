# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-${HOME}}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-${ZPLG_BIN_DIR_NAME}}:-bin}"
### Added by Zinit's installer
if [[ ! -f "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# Initialize command prompt
export PS1="%n@%m:%~%# "

# Enable 256 color to make auto-suggestions look nice
[[ $TERM == screen* ]] && export TERM="screen-256color"
[[ $TERM == xterm* ]] && export TERM="xterm-256color"

# Load local bash/zsh compatible settings
_INIT_SH_NOFUN=1
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh"
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"
[ -f "$HOME/.local/etc/function.sh" ] && . "$HOME/.local/etc/function.sh"

# check login shell
if [[ -o login ]]; then
    [ -f "$HOME/.local/etc/login.sh" ] && source "$HOME/.local/etc/login.sh"
    [ -f "$HOME/.local/etc/login.zsh" ] && source "$HOME/.local/etc/login.zsh"
fi

# exit for non-interactive shell
[[ $- != *i* ]] && return

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE

#### PLUGIN START ####

alias zt='zinit wait lucid depth=3'

### Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Trigger-load
zinit light-mode for \
    trigger-load'!x' svn \
        OMZP::extract \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!zhooks' \
        agkozak/zhooks \
    trigger-load'!ccat;!cless' \
        OMZP::colorize/colorize.plugin.zsh \
    trigger-load'!alias-finder' \
        OMZP::alias-finder/alias-finder.plugin.zsh \
    trigger-load'!\=' \
        arzzen/calc.plugin.zsh \
    trigger-load'!cpv' \
        OMZP::cp/cp.plugin.zsh

### OMZ basics
zinit light-mode for \
        OMZL::completion.zsh \
        OMZL::history.zsh \
        OMZL::key-bindings.zsh \
    atload'export LSCOLORS="ExgxcxdxCxegedabagacad"' \
        OMZL::theme-and-appearance.zsh
setopt CORRECT
DISABLE_MAGIC_FUNCTIONS=true
DISABLE_AUTO_TITLE=true

### Important aliases & functions
zinit aliases light-mode for \
        OMZL::directories.zsh \
        OMZP::common-aliases/common-aliases.plugin.zsh \
    blockf atload'export ZSH_TMUX_FIXTERM=false' \
        OMZP::tmux/tmux.plugin.zsh
zinit light lljbash/zsh-renew-tmux-env

### Other plugins
zt light-mode for \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
        OMZP::command-not-found/command-not-found.plugin.zsh \
        OMZP::safe-paste/safe-paste.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
    atload'export HISTORY_START_WITH_GLOBAL=true' \
        OMZP::per-directory-history/per-directory-history.zsh \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
        hlissner/zsh-autopair \
    atclone'dircolors -b LS_COLORS > lscolors.zsh' atpull'%atclone' \
    nocompletions pick'lscolors.zsh' \
        trapd00r/LS_COLORS \
    pick'autoenv.zsh' nocompletions \
        Tarrasch/zsh-autoenv \
    blockf \
        agkozak/zsh-z \
    as'null' atload'export CCLS_INIT_CONFIG=$(pwd)/ccls-config;
                    alias ccls-init='\''cp $CCLS_INIT_CONFIG .ccls'\''' \
        'https://github.com/lljbash/configs/blob/master/ccls-config'

### Aliases
zt aliases light-mode for \
        OMZL::git.zsh \
    blockf \
        OMZP::git/git.plugin.zsh \
        OMZP::nmap/nmap.plugin.zsh \
        OMZP::rsync/rsync.plugin.zsh \
    blockf \
        OMZP::ubuntu/ubuntu.plugin.zsh \
        'https://github.com/lljbash/configs/blob/master/my_aliases.zsh'

### Binaries
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zt as "null" from"gh-r" nocompile light-mode for \
    mv"fd* -> fd" sbin"fd/fd" atload"unalias fd &>/dev/null" \
        @sharkdp/fd \
    mv"delta* -> delta" sbin"delta/delta" \
    atclone"sed -e '1,/\`\`\`gitconfig/d' -e '/\`\`\`/,\$d' delta/README.md > gitconfig;
            git config --global include.path \$(pwd)/gitconfig" \
    atpull'%atclone' \
        dandavison/delta
zt as "null" nocompile light-mode for \
    atclone"sed --in-place=.orig -e 's/github.com\/junegunn\/fzf\/releases/download.fastgit.org\/junegunn\/fzf\/releases/' install; ./install --bin" reset atpull'%atclone' sbin"bin/fzf" \
    atload'export FZF_DEFAULT_COMMAND="fd --type f"; export FZF_BASE=$(pwd)' \
        junegunn/fzf
## With completions
zt as"completion" blockf from"gh-r" nocompile light-mode for \
    cp"comp*/*.zsh -> _exa" sbin"bin/exa" \
    atload'_lljbash_exa_icons() {
               if [[ $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(r)os_icon] == os_icon ]]; then
                   echo "--icons"
               fi
           }
           alias ls='\''exa'\'';
           alias l='\''exa -lbF --git $(_lljbash_exa_icons)'\'';
           alias ll='\''exa -lbGF --git $(_lljbash_exa_icons)'\'';
           alias llm='\''exa -lbGd --git --sort=modified $(_lljbash_exa_icons)'\'';
           alias la='\''exa -lbFa --git $(_lljbash_exa_icons)'\'';
           alias lx='\''exa -lbhHigUmuSa@ --time-style=long-iso --git \
                     --color-scale $(_lljbash_exa_icons)'\'';
           alias lS='\''exa -1'\'';
           alias lt='\''exa -FT $(_lljbash_exa_icons)'\''
           alias lta='\''exa -FTa --ignore-glob=.git $(_lljbash_exa_icons)'\''
           alias llt='\''exa -lbFT --git $(_lljbash_exa_icons)'\''
           alias llta='\''exa -lbFTa --git --ignore-glob=.git $(_lljbash_exa_icons)'\''' \
        ogham/exa \
    mv"ripgrep* -> ripgrep" cp"ripgrep/comp*/_rg -> _rg" sbin"ripgrep/rg" \
    atclone"rm -rf ripgrep/comp*" atpull'%atclone' \
        BurntSushi/ripgrep \
    atclone'./just --completions zsh > _just' atpull'%atclone' sbin \
        casey/just \
    atclone'mv bat* bat; mv -f **/*.zsh _bat' atpull'%atclone' sbin"bat/bat" \
        @sharkdp/bat
## Actually scripts
zt as"null" light-mode nocompile for \
    sbin"bin/git-ignore" \
        laggardkernel/git-ignore

### Completions
zt light-mode for \
    blockf \
        OMZP::fzf/fzf.plugin.zsh \
    as"completion" blockf \
        OMZP::fd/_fd \
    as"completion" blockf \
        "https://github.com/jonathanpoelen/dotfiles/blob/master/.zshcompletions/_delta" \
    blockf \
        zsh-users/zsh-completions \
    blockf compile'lib/*f*~*.zwc' \
    atinit'zicompinit; zicdreplay; compdef _delta delta' \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(fzf-tab)' \
        Aloxaf/fzf-tab

### Highlighting
zt light-mode for \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    compile'.*fast*~*.zwc' nocompletions atpull'%atclone' \
    atload'fast-theme -q clean' \
        zdharma-continuum/fast-syntax-highlighting \

### Cleanup
zt as"null" light-mode for \
    id-as'Cleanup' nocd atinit'unalias zt &>/dev/null; _zsh_autosuggest_bind_widgets' \
        zdharma-continuum/null

#### PLUGIN  END  ####
