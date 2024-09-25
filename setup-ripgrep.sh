#!/bin/bash
set -eu

repo_url=https://github.com/BurntSushi/ripgrep
version=14.1.1
release=1

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if [ "$(dpkg-query -f '${Version}' -W nfpm 2>/dev/null)" != "$version-$release" ]; then
  arch=$(dpkg --print-architecture)
  deb_filename=ripgrep_${version}-${release}_${arch}.deb
  deb_url=$repo_url/releases/download/${version}/${deb_filename}
  install_deb_packages curl
  curl -sSLo /tmp/$deb_filename $deb_url
  sudo dpkg -i /tmp/$deb_filename
fi
