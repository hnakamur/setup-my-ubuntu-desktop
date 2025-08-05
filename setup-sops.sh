#!/bin/bash
set -eu
repo_url=https://github.com/getsops/sops

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
installed_version=$(sops --version 2>/dev/null | head -1 | cut -d ' ' -f 2)
if [ v"$installed_version" != "$version" ]; then
  mkdir -p ~/.local/bin
  arch=$(dpkg --print-architecture)
  curl -fsSL -o ~/.local/bin/sops ${repo_url}/releases/download/${version}/sops-${version}.linux.${arch}
  chmod +x ~/.local/bin/sops
fi
