#!/bin/bash
set -eu
repo_url=https://github.com/zellij-org/zellij

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')
installed_version=$(zellij --version 2>/dev/null | cut -d ' ' -f 2)
if [ "$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(uname -m)
  curl -fsSL ${repo_url}/releases/download/v${version}/zellij-${arch}-unknown-linux-musl.tar.gz | tar zx -C ~/.local/bin/
fi
