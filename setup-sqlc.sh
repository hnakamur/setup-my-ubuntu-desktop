#!/bin/bash
set -eu
repo_url=https://github.com/sqlc-dev/sqlc

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')
installed_version=$(sqlc version 2>/dev/null || :)
if [ "$installed_version" != v"$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(dpkg --print-architecture)
  curl -fsSL ${repo_url}/releases/download/v${version}/sqlc_${version}_linux_${arch}.tar.gz | tar zx -C ~/.local/bin/
fi
