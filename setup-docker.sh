#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_docker_apt_key() {
  if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  fi
}

add_apt_sources() {
  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
  fi
}

add_docker_group() {
  getent group docker > /dev/null || sudo groupadd -r docker
}

add_user_to_docker_group() {
  user="$1"
  group="$2"
  id -nGz "$user" | grep -qzxF "$group" || sudo usermod -aG "$group" "$user"
}


install_deb_packages ca-certificates curl gnupg lsb-release
install_docker_apt_key
add_apt_sources
install_deb_packages docker-ce docker-ce-cli containerd.io docker-compose-plugin
add_docker_group
add_user_to_docker_group "$USER" docker
