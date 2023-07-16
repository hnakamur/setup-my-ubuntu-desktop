#!/bin/bash
set -eu

apt_key_file=/etc/apt/keyrings/keepassxc.asc
apt_source_file=/etc/apt/sources.list.d/keepassxc.list
distrib=$(lsb_release -is | tr A-Z a-z)

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_docker_apt_key() {
  if [ ! -f "$apt_key_file" ]; then
    sudo curl -fsSL -o "$apt_key_file" "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xd89c66d0e31fea2874ebd20561922ab60068fcd6"
  fi
}

add_apt_sources() {
  if [ ! -f "$apt_source_file" ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=$apt_key_file] \
      https://ppa.launchpadcontent.net/phoerious/keepassxc/$distrib \
      $(lsb_release -cs) main" \
      | sudo tee "$apt_source_file" > /dev/null
    sudo apt-get update
  fi
}

install_deb_packages curl
install_docker_apt_key
add_apt_sources
install_deb_packages keepassxc
