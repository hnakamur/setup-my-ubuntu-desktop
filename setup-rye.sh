#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_rye() {
  if ! type rye 2>/dev/null; then
    curl -sSf https://rye-up.com/get | bash
  fi
}

install_deb_packages curl
install_rye
