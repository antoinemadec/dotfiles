#!/usr/bin/env bash


# install all program using the intall scripts in this directory following:
#   ./install_<program_name>.bash
#
# for each install script:
#   + $1 is the source_dir
#   + it must ONLY echo the relative path to its binary
#
# each program will be build in:
#   ~/source/<release_name>
# and a files exporting functions pointing to the binaries will be created at:
#   ~/.install.bash

set -e

release_string="$(get_release_string)"
rm -f ~/.install.bash

cd "$(dirname $0)"
for install_cmd in install_*.bash
do
  echo "--- $install_cmd:"
  program_name="$(echo $install_cmd | sed -e 's/^install_//' -e 's/.bash$//')"
  source_dir="$(readlink -m ~/source/$release_string/$program_name)"
  mkdir -p "$source_dir"
  bin_path="$(./$install_cmd $source_dir/)"
  [ "$bin_path" = "" ] && exit 1
  cat << EOF >> ~/.install.bash
$program_name() {
  ~/source/\$(get_release_string)/$program_name/$bin_path "\$@"
}
export -f $program_name

EOF
done
