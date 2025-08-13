#!/bin/bash
set -eu
repo_url=https://github.com/bytecodealliance/javy

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
installed_version=$(javy --version 2>/dev/null | cut -d ' ' -f 2)
if [ v"$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  cpu_type=$(uname -p)
  curl -fsSL ${repo_url}/releases/download/${version}/javy-${cpu_type}-linux-${version}.gz | gzip -cd > ~/.local/bin/javy
  chmod +x ~/.local/bin/javy
fi
