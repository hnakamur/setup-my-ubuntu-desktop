#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if ! type volta >& /dev/null; then
  install_deb_packages curl
  curl https://get.volta.sh | bash
  echo 'export VOLTA_FEATURE_PNPM=1' >> $HOME/.bashrc
fi
