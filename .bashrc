# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export SHELL=/bin/bash

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=4000000
HISTFILESIZE=4000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  [ "$LS_COLORS" = "" ] && source ~/bin/source_conditional/ls_colors.bash
  alias ls='ls -h --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# # less/man colors
if (type nvim &> /dev/null); then
  export MANPAGER='nvim --cmd "let g:man_mode=1" +Man!'
  export MANWIDTH=999
else
  export MANROFFOPT="-c"
  export LESS=-R
  export LESS_TERMCAP_md=$'\e[01;31m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;44;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[01;32m'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# disable the bell
xset b off

# xterm title
eval_xterm_title() {
  local XTERM_TITLE='${USER}@${HOSTNAME/.*}:${PWD/$HOME/\~}'
  eval "echo -ne \"\033]0;${XTERM_TITLE}\007\""
}
PROMPT_COMMAND="eval_xterm_title; $PROMPT_COMMAND"

#--------------------------------------------------------------
# prompt
#--------------------------------------------------------------
if tput colors &> /dev/null
then
  # see man 4 console_codes
  # \[ and \] are used in bash prompt (see man bash PROMPTING) to start and
  # end a sequence character so size of prompt is correctly computed.
  export COLOR_BLACK="\[\033[0;30m\]"
  export COLOR_DARKGRAY="\[\033[1;30m\]"
  export COLOR_RED="\[\033[0;31m\]"
  export COLOR_LIGHT_RED="\[\033[1;31m\]"
  export COLOR_GREEN="\[\033[0;32m\]"
  export COLOR_LIGHT_GREEN="\[\033[1;32m\]"
  export COLOR_YELLOW="\[\033[0;33m\]"
  export COLOR_LIGHT_YELLOW="\[\033[1;33m\]"
  export COLOR_BLUE="\[\033[0;34m\]"
  export COLOR_LIGHT_BLUE="\[\033[1;34m\]"
  export COLOR_PURPLE="\[\033[0;35m\]"
  export COLOR_LIGHT_PURPLE="\[\033[1;35m\]"
  export COLOR_CYAN="\[\033[0;36m\]"
  export COLOR_LIGHT_CYAN="\[\033[1;36m\]"
  export COLOR_GRAY="\[\033[0;37m\]"
  export COLOR_WHITE="\[\033[1;37m\]"
  export COLOR_NEUTRAL="\[\033[0m\]"
fi

# test speed of __git_ps1 with different options in background
# 200ms is the threshold; don't run it if current directory has not change
test_git_ps1_speed() {
  (
  local status="true"
  local t=$( (time GIT_PS1_SHOWDIRTYSTATE=true __git_ps1) 2>&1 | tail -n3 | grep real | sed -e 's/.*m//' -e 's/s//' -e 's/\.//' )
  [ "$t" -gt 200 ] && status="false"
  echo "$GIT_REPO $status" > $FANCY_PROMPT_GIT_FILE
  )& disown %-
}

FANCY_PROMPT_GIT_FILE="/tmp/git_ps1_speed_$(whoami)_$(tty | tr '/' _)"
fancy_prompt () {
  local return_code="$?"
  if [ "$return_code" = 0 ]
  then
      local arrow="${COLOR_GREEN}"
  else
      local arrow="${COLOR_RED}"
  fi
  local arrow+=">"
  GIT_REPO="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ "$GIT_REPO" != "" ]; then
    test_git_ps1_speed
    local ds_status=""
    local speed="$(cat $FANCY_PROMPT_GIT_FILE 2>/dev/null)"
    local speed_repo="${speed/ */}"
    local speed_status="${speed/* /}"
    [ "$speed_repo" = "$GIT_REPO" ] && [ "$speed_status" = "true" ] && ds_status="true"
    GIT_PS1_SHOWDIRTYSTATE="$ds_status"
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_DESCRIBE_STYLE="branch"
    local git=$(__git_ps1 "${COLOR_NEUTRAL}on ${COLOR_CYAN}%s" 2> /dev/null)
    [ "$GIT_PS1_SHOWDIRTYSTATE" = "" ] && [ "$git" != "" ] && git+=" ${COLOR_GRAY}(no-ds)"
  fi
  local python_virtual_env=""
  [ "$VIRTUAL_ENV" != "" ] && python_virtual_env="${COLOR_GRAY}($(basename "$VIRTUAL_ENV")) "
  export PS1="${python_virtual_env}${COLOR_RED}\u${COLOR_NEUTRAL}@${HILIT}\h${COLOR_NEUTRAL}:${COLOR_YELLOW}\w ${git}${COLOR_NEUTRAL}\n$arrow${COLOR_NEUTRAL} "
}

if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
    HILIT=${COLOR_BLUE}   # remote machine
else
    HILIT=${COLOR_GREEN}  # local machine
fi

PROMPT_COMMAND="fancy_prompt ; $PROMPT_COMMAND"
#--------------------------------------------------------------

#--------------------------------------------------------------
# custom aliases
#--------------------------------------------------------------
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# use setW to set directory
# use W to jump to that dir
W(){
  local dir_file=~/work_dir.txt
  [ -f $dir_file ] || return
  local dir_nb="$(wc -l $dir_file | cut -d ' ' -f 1)"
  if [ "$dir_nb" -eq 1 ]
  then
    cd "$(cat $dir_file)"
  elif [ "$dir_nb" -ge 2 ]
  then
    cat -n $dir_file
    echo "Enter nb:"
    read nb
    cd "$(head -n$nb $dir_file | tail -n1)"
  fi
}

mkcd() {
  mkdir -p $1
  cd $1
}
#--------------------------------------------------------------

# use vim in Git and other programs
export VISUAL=nvim
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# use remote nvim when in nvim terminal
[ "$NVIM" != "" ] && alias nvim="nvim_server_open"

# lightweight nvim for big files
alias lvim='nvim --cmd "let g:light_mode=1"'

# source files
for file in ~/bin/source/*
do
  [ -f $file ] && source $file
done
type __git_ps1 &>/dev/null || source /usr/share/git/git-prompt.sh &> /dev/null || source ~/bin/source_conditional/git_ps1

# path
# -- custom bins
pre_path ~/bin
for file in ~/bin/completion/*
do
  [ -f $file ] && source $file
done
[ -d ~/src/$(get_release_string)/bin ] && pre_path ~/src/$(get_release_string)/bin
add_path /snap/bin
# -- other
add_path /usr/sbin
[ -d ~/.npm-global/bin ] && pre_path ~/.npm-global/bin

# term capabilities
tput ritm && export TERM_ITALICS=true
export TERM_COLORS="$(tput colors)"
export TERM_FANCY_CURSOR=true     # can be modified in .bashrc.local
export TERM_BRACKETED_PASTE=true  # can be modified in .bashrc.local

# tmux
TMUX_SESSION=""
if [[ -n "${TMUX+set}" ]]; then
  TMUX_SESSION="$(tmux display-message -p "#S")"
fi
export TMUX_SESSION

# local aliases, modifications etc
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# fzf: fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--layout=reverse --info=inline'
if (type ag &> /dev/null) && (type fzf &> /dev/null)
then
  export FZF_DEFAULT_COMMAND='ag --follow -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# expand $VAR when VAR is a directory
shopt -s direxpand
compopt -o nospace ls

# bat default style: used for FZF preview in vim
export BAT_THEME="1337"
