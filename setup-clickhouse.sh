#!/bin/bash

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if ! type clickhouse-client 2>/dev/null; then
  # https://github.com/zabbly/incus

  key_path=/etc/apt/keyrings/clickhouse-keyring.gpg
  if [ ! -f "$key_path" ]; then
    install_deb_packages apt-transport-https ca-certificates curl gnupg

    sudo mkdir -p $(dirname "$key_path")
    curl -sSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | sudo gpg --dearmor -o "$key_path"
  fi

  list_path=/etc/apt/sources.list.d/clickhouse.list
  if [ ! -f "$list_path" ]; then
    echo "deb [signed-by=$key_path] https://packages.clickhouse.com/deb stable main" | sudo tee "$list_path" >/dev/null
  fi

  sudo apt-get update
  sudo apt-get -y install clickhouse-server clickhouse-client
fi
