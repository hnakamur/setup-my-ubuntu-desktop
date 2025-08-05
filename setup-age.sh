#!/bin/bash
set -eu
repo_url=https://github.com/FiloSottile/age

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
installed_version=$(age --version 2>/dev/null || :)
if [ "$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(dpkg --print-architecture)
  curl -fsSL ${repo_url}/releases/download/${version}/age-${version}-linux-${arch}.tar.gz | tar -C ~/.local/bin/ --strip-components=1 -zxf - age/age age/age-keygen
fi
