#!/bin/bash
set -eu

install_mold() {
  repo_url=https://github.com/rui314/mold
  latest_version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's/^v//')
  installed_version=$(mold -v 2> /dev/null | cut -f 2 -d ' ')
  if dpkg --compare-versions "$installed_version" lt "$latest_version" ; then
    curl -sSL "$repo_url/releases/download/v${latest_version}/mold-${latest_version}-x86_64-linux.tar.gz" \
      | sudo tar -zxf - -C /usr/local --strip-components=1
  fi
}

install_mold
