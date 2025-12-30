#!/bin/bash
set -eu
repo_url=https://github.com/junegunn/fzf

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')
installed_version=$(fzf --version 2>/dev/null | cut -d ' ' -f 1)
if [ "$installed_version" != "$version" ]; then
  dest_dir="$HOME/.local/bin"
  mkdir -p "$dest_dir"
  arch=$(dpkg --print-architecture)
  curl -fsSL ${repo_url}/releases/download/v${version}/fzf-${version}-linux_${arch}.tar.gz | tar zx -C "$dest_dir"
fi
