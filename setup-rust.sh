#!/bin/bash
set -eu

install_rustup() {
  rustup_path="$HOME/.cargo/bin/rustup"
  if [ ! -f "$rustup_path" ]; then
    rustup_init=$(mktemp '/tmp/rustup-init.XXXXXXX')
    curl -o "$rustup_init" --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
    sh "$rustup_init" -y
    rm -f "$rustup_init"
  fi
  source "$HOME/.cargo/env"
}

install_rust_nightly() {
  if ! rustup toolchain list | grep -q nightly; then
    rustup install nightly
  fi
}

install_rustup_nightly_components() {
  installed=$(rustup +nightly component list --installed)
  for comp in "$@"; do
    echo "$installed" | grep -qxF "$comp-x86_64-unknown-linux-gnu" || echo "$comp"
  done | xargs -r -n 1 rustup +nightly component add
}

install_cargo_tools() {
  installed_tools=$(cargo install --list | grep ':$' | cut -f 1 -d ' ')
  for tool in "$@"; do
    echo "$installed_tools" | grep -qxF "$tool" || echo "$tool"
  done | xargs -r -n 1 cargo install
}

install_rustup
install_rust_nightly
install_cargo_tools cargo-edit cargo-make

# If this fails, install miri manually.
# See https://github.com/rust-lang/miri#using-miri
install_rustup_nightly_components miri
