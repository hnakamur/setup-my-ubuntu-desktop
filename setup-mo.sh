#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl tar gzip

repo_url=https://github.com/k1LoW/mo
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')

installed_version=$(mo --version 2>/dev/null | cut -d ' ' -f 3)
if [ "$installed_version" != "$version" ]; then
  bin_dir=$HOME/.local/bin
  mkdir -p "$bin_dir"
  curl -L ${repo_url}/releases/download/v${version}/mo_v${version}_linux_amd64.tar.gz | tar zx -C ${bin_dir} mo
fi
