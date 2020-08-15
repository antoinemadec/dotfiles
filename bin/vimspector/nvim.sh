#!/bin/bash

set -e

ln -sf build/compile_commands.json

echo 'make CMAKE_BUILD_TYPE=Debug' > debug_make.sh
chmod +x debug_make.sh
./debug_make.sh
