#!/bin/bash
set -eu

install_deb_packages() {
  local pkg
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W "${pkg}" 2>/dev/null)" != 'install ok installed' ]; then
      echo "${pkg}"
    fi
  done | xargs -r sudo apt-get install -y
}

install_docker_apt_key() {
  local apt_key_file="$1"
  if [ ! -f "$apt_key_file" ]; then
    # shellcheck disable=SC2018,SC2019
    distrib=$(lsb_release -is | tr A-Z a-z)
    sudo curl -fsSL -o "$apt_key_file" "https://download.docker.com/linux/${distrib}/gpg"
  fi
}

add_apt_sources() {
  local apt_key_file="$1"
  codename=$(lsb_release -cs)
  if [ ! -f /etc/apt/sources.list.d/docker.sources ]; then
    # shellcheck disable=SC2018,SC2019
    distrib=$(lsb_release -is | tr A-Z a-z)
      cat <<EOF | sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null
Enabled: yes
Types: deb
URIs: https://download.docker.com/linux/$distrib
Suites: $codename
Components: stable
Signed-By: $apt_key_file
Architectures: $(dpkg --print-architecture)
EOF
    sudo apt-get update
  fi
}

add_docker_group() {
  getent group docker > /dev/null || sudo groupadd -r docker
}

add_user_to_docker_group() {
  local user="$1"
  local group="$2"
  id -nGz "$user" | grep -qzxF "$group" || sudo usermod -aG "$group" "$user"
}

main() {
  local rootless=0
  case "${1:-}" in
  --rootless)
    # NOTE: I failed to run rootless docker in an Incus container.
    # It works fine on a Ubuntu host server.
    rootless=1
    ;;
  esac

  install_deb_packages ca-certificates curl lsb-release
  apt_key_file=/etc/apt/keyrings/docker.asc
  install_docker_apt_key "${apt_key_file}"
  add_apt_sources "${apt_key_file}"
  install_deb_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  add_docker_group
  add_user_to_docker_group "$USER" docker

  if [ "${rootless}" -ne 0 ]; then
    install_deb_packages uidmap
    sudo systemctl disable --now docker.service docker.socket
    sudo rm /var/run/docker.sock
    dockerd-rootless-setuptool.sh install
  fi
}

main
