#!/bin/bash
set -eu

CMAKE_VERSION=3.27.9

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

installed_version=$(cmake --version 2>/dev/null | head -1 | cut -d ' ' -f 3)
if [ "$installed_version" != "$CMAKE_VERSION" ]; then
  install_deb_packages curl
  download_url=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz
  curl -sSL "$download_url" | sudo tar zxf - -C /usr/local/
  (cd /usr/local/bin; sudo ln -s ../cmake-${CMAKE_VERSION}-linux-x86_64/bin/* .)
fi
