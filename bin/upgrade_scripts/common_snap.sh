snap_install_refresh() {
  package="$1"
  shift
  install_options="$@"

  if snap list $package; then
    sudo snap refresh $package
  else
    sudo snap install $package $install_options
  fi
}
