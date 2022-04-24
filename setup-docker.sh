#!/bin/bash
set -eu

not_installed_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done
}

install_deb_packages() {
  pkgs=$(not_installed_deb_packages "$@")
  if [ -n "$pkgs" ]; then
    sudo apt-get install -y $pkgs
  fi
}

add_user_to_group() {
  user="$1"
  group="$2"
  id -nGz "$user" | grep -qzxF "$group" || sudo usermod -aG "$group" "$user"
}

install_deb_packages docker.io
add_user_to_group "$USER" docker
