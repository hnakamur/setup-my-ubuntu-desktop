#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl unzip

repo_url=https://github.com/x-motemen/ghq
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')

installed_version=$(ghq -version 2>/dev/null | cut -d ' ' -f 3)
if [ "v$installed_version" != "$version" ]; then
  bin_dir=$HOME/.local/bin
  zip_path=/tmp/ghq_linux_amd64.zip
  mkdir -p "$bin_dir"
  curl -L -o ${zip_path} ${repo_url}/releases/download/${version}/ghq_linux_amd64.zip
  unzip -j ${zip_path} ghq_linux_amd64/ghq -d "$bin_dir"
fi
