#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl

if ! type zigup >& /dev/null; then
  tarball_url=https://github.com/marler8997/zigup/releases/latest/download/zigup-x86_64-linux.tar.gz
  install_dir="$HOME/.local/bin"
  mkdir -p "$install_dir"
  curl -sSL "$tarball_url" | tar zxf - -C "$install_dir"
fi
