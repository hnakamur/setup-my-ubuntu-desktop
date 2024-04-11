#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl unzip

if ! type zigup >& /dev/null; then
  zip_url=https://github.com/marler8997/zigup/releases/latest/download/zigup.ubuntu-latest-x86_64.zip
  curl -sSLo /tmp/zigup.ubuntu-latest-x86_64.zip "$zip_url"
  mkdir -p "$HOME/.local/bin"
  unzip -q /tmp/zigup.ubuntu-latest-x86_64.zip zigup -d "$HOME/.local/bin"
  chmod +x "$HOME/.local/bin/zigup"
fi
