#!/bin/bash
set -eu
repo_url=https://github.com/mislav/hub

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's|^v||')
installed_version=$(hub --version 2>/dev/null | sed -n '/^hub version/s/^hub version //p')
if [ "$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(dpkg --print-architecture)
  curl -fsSL ${repo_url}/releases/download/v${version}/hub-linux-${arch}-${version}.tgz | tar -C ~/.local/bin/ --strip-components=2 -zxf - hub-linux-${arch}-${version}/bin/hub 
fi

