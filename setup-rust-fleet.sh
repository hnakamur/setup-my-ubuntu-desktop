#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" == 'install ok installed' ] || echo $pkg
  done | xargs -r sudo apt-get install -y
}

not_install_cargo_tools() {
  installed_tools=$(cargo install --list | grep ':$' | cut -f 1 -d ' ')
  for tool in "$@"; do
    echo "$installed_tools" | grep -qxF "$tool" || echo "$tool"
  done
}

install_rust_fleet() {
  not_installed=$(not_install_cargo_tools fleet-rs sccache)
  if [ -n "$not_installed" ]; then
    curl -L get.fleet.rs | sh
  fi
}

install_deb_packages lld clang
# rustup default nightly
install_rust_fleet
