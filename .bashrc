# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export SHELL=/bin/bash

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=4000000
HISTFILESIZE=4000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# less/man colors
export LESS=-R
export LESS_TERMCAP_md=$'\E[38;5;214m' # begin blink
export LESS_TERMCAP_us=$'\E[38;5;203m' # begin underline
export LESS_TERMCAP_mb=$'\E[38;5;108m' # begin bold
export LESS_TERMCAP_so=$'\E[48;5;66m'  # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink

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

#--------------------------------------------------------------
# xterm title
#--------------------------------------------------------------
case "$TERM" in
  xterm*|rxvt*)
    # TODO: remove VIM test when vim is fixed
    if [ -f /etc/profile.d/vte-2.91.sh ] && [ "$VIM" = "" ]
    then
      . /etc/profile.d/vte-2.91.sh
    else
      XTERM_TITLE='${USER}@${HOSTNAME/.*}:${PWD/$HOME/\~}'
      PROMPT_COMMAND='eval "echo -ne \"\033]0;${XTERM_TITLE}\007\""'
    fi
    ;;
  *)
    ;;
esac
#--------------------------------------------------------------

#--------------------------------------------------------------
# prompt
#--------------------------------------------------------------
# termite is sometimes not recognized as a TERM type
if [ $TERM == xterm-termite ] && ! (tput colors &> /dev/null)
then
  wget https://raw.githubusercontent.com/thestinger/termite/master/termite.terminfo --no-check-certificate
  tic -x termite.terminfo
fi

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
  export COLOR_BROWN="\[\033[0;33m\]"
  export COLOR_YELLOW="\[\033[1;33m\]"
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
  local file="$1"
  local repo="$2"
  (
  local status="true"
  local t=$( (time (GIT_PS1_SHOWDIRTYSTATE=true __git_ps1)) 2>&1 | grep real | sed -e 's/.*m//' -e 's/s//' -e 's/\.//' )
  [ "$t" -gt 200 ] && status="false"
  echo "$repo $status" > $file
  )& disown %-
}

fancy_prompt () {
  local return_code="$?"
  if [ "$return_code" = 0 ]
  then
      local arrow="${COLOR_LIGHT_GREEN}"
  else
      local arrow="${COLOR_RED}"
  fi
  local arrow+=">"
  local git_ds_file="/tmp/git_ps1_speed_$(whoami)_$(tty | sed 's#/#_#g')"
  local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
  test_git_ps1_speed "$git_ds_file" "$repo"
  local ds_status=""
  local speed_repo="$(cat $git_ds_file   2>/dev/null | cut -d ' ' -f1)"
  local speed_status="$(cat $git_ds_file 2>/dev/null | cut -d ' ' -f2)"
  [ "$speed_repo" = "$repo" ] && [ "$speed_status" = "true" ] && ds_status="true"
  GIT_PS1_SHOWDIRTYSTATE="$ds_status"
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_DESCRIBE_STYLE="branch"
  local git=$(__git_ps1 "${COLOR_NEUTRAL}on ${COLOR_LIGHT_CYAN}%s" 2> /dev/null)
  local python_virtual_env=""
  [ "$VIRTUAL_ENV" != "" ] && python_virtual_env="${COLOR_GRAY}($(basename "$VIRTUAL_ENV")) "
  [ "$GIT_PS1_SHOWDIRTYSTATE" = "" ] && [ "$git" != "" ] && git+=" ${COLOR_GRAY}(no-ds)"
  export PS1="${python_virtual_env}${COLOR_RED}\u${COLOR_NEUTRAL}@${HILIT}\h${COLOR_NEUTRAL}:${COLOR_YELLOW}\w ${git}${COLOR_NEUTRAL}\n$arrow${COLOR_NEUTRAL} "
}

if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
    HILIT=${COLOR_LIGHT_BLUE}   # remote machine
else
    HILIT=${COLOR_LIGHT_GREEN}  # local machine
fi

# execute xterm_autotitle for each prompt
if [ "$PROMPT_COMMAND" = "" ]
then
  PROMPT_COMMAND="fancy_prompt"
else
  PROMPT_COMMAND="fancy_prompt ; $PROMPT_COMMAND"
fi
#--------------------------------------------------------------

#--------------------------------------------------------------
# custom aliases
#--------------------------------------------------------------
# tmux in 256 colors
alias tmux='tmux -2'

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
export VISUAL=vim
export EDITOR="$VISUAL"

# source files
for file in ~/bin/source/*
do
  [ -f $file ] && source $file
done
type __git_ps1 &>/dev/null || source ~/bin/source_conditional/git_ps1

# put custom binaries in ~/bin
add_path ~/bin
for file in ~/bin/completion/*
do
  [ -f $file ] && source $file
done
[ -d ~/src/$(get_release_string)/bin ] && pre_path ~/src/$(get_release_string)/bin

# term capabilities
tput ritm && export TERM_ITALICS=true
export TERM_COLORS="$(tput colors)"
export TERM_FANCY_CURSOR=true     # can be modified in .bashrc.local
export TERM_BRACKETED_PASTE=true  # can be modified in .bashrc.local

# local aliases, modifications etc
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# fzf: fuzzy search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if (type ag &> /dev/null) && (type fzf &> /dev/null)
then
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # vim grep
  g() {
    local ag_opts
    local file
    file="$(ag --nobreak --noheading . $1 | fzf -0 -1 | awk -F: '{print $1 " +" $2}')"
    if [[ -n $file ]]
    then
      vim $file
    fi
  }
fi
