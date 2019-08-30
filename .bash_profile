#! /bin/bash

if [ -f ~/.bashrc ]
then
  . ~/.bashrc
fi

export GPG_TTY=$(tty)
