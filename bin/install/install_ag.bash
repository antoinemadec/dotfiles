#!/usr/bin/env bash

set -e

SRC_DIR="$1"
cd $SRC_DIR

(
git clone git://github.com/ggreer/the_silver_searcher || :
cd the_silver_searcher
./build.sh
) &> install.log

echo "the_silver_searcher/ag"
