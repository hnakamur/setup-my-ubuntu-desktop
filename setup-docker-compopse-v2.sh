#!/bin/bash

not_installed_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done
}

install_deb_packages() {
  pkgs=$(not_installed_deb_packages "$@")
  if [ -n "$pkgs" ]; then
    sudo apt-get install -y $pkgs
  fi
}

install_deb_packages curl

repo_url=https://github.com/docker/compose
latest_version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's/^v//')

dest_path="$HOME/.docker/cli-plugins/docker-compose"
installed_version=$("$dest_path" version 2> /dev/null | cut -f 4 -d ' ' | sed 's/^v//')
if dpkg --compare-versions "$installed_version" lt "$latest_version" ; then
  curl -Lo "$dest_path" --create-dirs "$repo_url/releases/download/v${latest_version}/docker-compose-linux-x86_64"
  chmod 750 "$dest_path"
fi
