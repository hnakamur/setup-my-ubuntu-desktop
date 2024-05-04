#!/bin/bash
set -eu
destpath="$HOME/.local/bin/kind"

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl

repo_url=https://github.com/kubernetes-sigs/kind
latest_version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
installed_version=$(kind version 2>/dev/null | awk '{printf("%s", $2)}')
if [ "$installed_version" != "$latest_version" ]; then
  curl -sSLfo "$destpath" --create-dirs ${repo_url}/releases/download/${latest_version}/kind-linux-amd64
  chmod +x "$destpath"
fi
