#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_jq() {
  dest=/usr/local/bin/jq
  repo_url=https://github.com/jqlang/jq
  version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
  installed_version=$($dest --version 2>/dev/null || :)
  if [ "$installed_version" != "$version" ]; then
    sudo curl -L -o $dest ${repo_url}/releases/download/${version}/jq-linux-amd64
    sudo chmod +x $dest
  fi
}

install_deb_packages curl
install_jq
