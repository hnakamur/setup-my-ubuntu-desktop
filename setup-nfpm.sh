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

repo_url=https://github.com/goreleaser/nfpm
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')

if [ "$(dpkg-query -f '${Version}' -W nfpm 2>/dev/null)" != "$version" ]; then
  arch=$(dpkg --print-architecture)
  deb_filename=nfpm_${version}_${arch}.deb
  deb_url=$repo_url/releases/download/v${version}/${deb_filename}
  curl -sSLo /tmp/$deb_filename $deb_url
  sudo dpkg -i /tmp/$deb_filename
fi
