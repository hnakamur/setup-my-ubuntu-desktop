#!/bin/bash

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if type zfs >&/dev/null; then
  dataset=rpool/ROOT/ubuntu/var/lib/incus
  if ! zfs list "$dataset" >&/dev/null; then
    sudo zfs create "$dataset"
  fi
fi

if ! type incus 2>/dev/null; then
  codename=$(lsb_release -cs)
  # https://github.com/zabbly/incus

  if [ ! -f /etc/apt/keyrings/zabbly.asc ]; then
    install_deb_packages curl

    sudo mkdir -p /etc/apt/keyrings
    sudo curl -sSo /etc/apt/keyrings/zabbly.asc https://pkgs.zabbly.com/key.asc
  fi

  if [ ! -f /etc/apt/sources.list.d/zabbly-incus-stable.sources ]; then
    cat <<EOF | sudo tee /etc/apt/sources.list.d/zabbly-incus-stable.sources > /dev/null
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/incus/stable
Suites: $codename
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/zabbly.asc
EOF
  fi
  sudo apt-get update

  install_deb_packages incus
fi
