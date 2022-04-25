#!/bin/bash
set -eu

install_mold() {
  if [ ! -f /usr/local/bin/mold ]; then
    repo_url=https://github.com/rui314/mold
    version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's/^v//')
    curl -sSL "$repo_url/releases/download/v${version}/mold-${version}-x86_64-linux.tar.gz" | sudo tar -zxf - -C /usr/local --strip-components=1
  fi
}

install_mold
