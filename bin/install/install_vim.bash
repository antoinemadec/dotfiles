#!/usr/bin/env bash

set -e

SRC_DIR="$1"
cd $SRC_DIR
conf_options(){
cat << EOF
EOF
}

(
git clone git://github.com/vim/vim || :
cd vim
./configure                                                                 \
--prefix=$PWD                                                               \
--enable-multibyte                                                          \
--enable-perlinterp=dynamic                                                 \
--enable-pythoninterp                                                       \
--with-python-config-dir=$(readlink -e /usr/lib/python*/config* | head -n1) \
--enable-cscope                                                             \
--enable-gui=auto                                                           \
--with-features=huge                                                        \
--with-x                                                                    \
--enable-fontset                                                            \
--enable-largefile                                                          \
--disable-netbeans                                                          \
--with-compiledby="antoinemadec"                                            \
--enable-fail-if-missing
make
make install
) &> install.log

echo "vim/bin/vim"
