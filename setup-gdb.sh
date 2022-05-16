#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

setup_dbgsym_apt_line() {
  if [ ! -f /etc/apt/sources.list.d/dbgsym.list ]; then
    release=$(lsb_release -cs)
    cat <<EOF | sudo tee /etc/apt/sources.list.d/dbgsym.list > /dev/null
deb http://ddebs.ubuntu.com ${release} main restricted universe multiverse
deb http://ddebs.ubuntu.com ${release}-updates main restricted universe multiverse
deb http://ddebs.ubuntu.com ${release}-proposed main restricted universe multiverse
EOF
    sudo apt-get update
  fi
}

setup_libc_source() {
  basedirname="libc-src-deb"
  if [ ! -d "$HOME/$basedirname" ]; then
    mkdir -p "$HOME/$basedirname"
    cd "$HOME/$basedirname"
    apt-get source glibc
    glibcdir=$(ls -d glibc-*)
    echo "directory ~/$basedirname/$glibcdir" >> "$HOME/.gdbinit"
  fi
}

install_deb_packages ubuntu-dbgsym-keyring glibc-source gdb
setup_dbgsym_apt_line
setup_libc_source
