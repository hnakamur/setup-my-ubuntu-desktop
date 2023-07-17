#!/bin/bash
set -eu

repo_url=https://github.com/hnakamur/keepassxc-deb

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages git

version=$(git ls-remote --tags --refs --sort=committerdate "$repo_url" | tail -1 | sed 's|.*tags/||')
installed_version=$(dpkg-query -f '${Version}' -W keepassxc 2>/dev/null || :)
if [ "$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(dpkg --print-architecture)
  deb_filename=keepassxc_${version}_${arch}.deb
  curl -fsSLo /tmp/${deb_filename} ${repo_url}/releases/download/${version}/${deb_filename}
  sudo dpkg -i /tmp/${deb_filename}
  sudo apt-get -y install -f
fi

