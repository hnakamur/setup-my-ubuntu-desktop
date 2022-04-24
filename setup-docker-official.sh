#!/bin/bash
set -eu

# https://docs.docker.com/engine/install/ubuntu/

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


install_deb_packages ca-certificates curl gnupg lsb-release

if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
fi

if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

pkgs=$(not_installed_deb_packages docker-ce docker-ce-cli containerd.io)
if [ -n "$pkgs" ]; then
  sudo apt-get update
  sudo apt-get install -y $pkgs
fi
