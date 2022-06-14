#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

// See https://askubuntu.com/a/1209777/707184
install_tips_txt() {
  dest=/usr/share/doc/perf-tip/tips.txt
  url=https://raw.githubusercontent.com/torvalds/linux/master/tools/perf/Documentation/tips.txt
  if [ ! -f "$dest" ]; then
    sudo curl -sS --create-dirs -o "$dest" "$url"
  fi
}

install_deb_packages linux-tools-common
install_tips_txt
