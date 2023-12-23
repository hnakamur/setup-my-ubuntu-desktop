#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

apt_key_file=/etc/apt/keyrings/docker.asc
install_deb_packages ca-certificates curl lsb-release
distrib=$(lsb_release -is | tr A-Z a-z)

install_docker_apt_key() {
  if [ ! -f "$apt_key_file" ]; then
    sudo curl -fsSL -o "$apt_key_file" https://download.docker.com/linux/$distrib/gpg
  fi
}

add_apt_sources() {
  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=$apt_key_file] https://download.docker.com/linux/$distrib \
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


install_docker_apt_key
add_apt_sources
install_deb_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
add_docker_group
add_user_to_docker_group "$USER" docker
