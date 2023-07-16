#!/bin/bash
set -eu

extensions="
  golang.go
  matklad.rust-analyzer
  tamasfe.even-better-toml
"

install_deb_packages() {
  for pkg in "$@"; do
    [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" == 'install ok installed' ] || echo $pkg
  done | xargs -r sudo apt-get install -y
}

install_extensions() {
  installed_extensions=$(code --list-extensions)
  for ext in "$@"; do
    echo "$installed_extensions" | grep -qzFi "$ext" || echo "$ext"
  done | xargs -r -n 1 code --install-extension
}

uninstall_extensions() {
  echo "$@" | xargs -r -n 1 code --uninstall-extension
}

install_apt_key() {
  key_url="$1"
  key_path="$2"
  if [ ! -f "$key_path" ]; then
    sudo curl -sS -o "$key_path" "$key_url"
  fi
}

add_apt_list() {
  apt_line="$1"
  apt_list_path="$2"
  if [ ! -f "$apt_list_path" ]; then
    echo "$apt_line" | sudo tee "$apt_list_path" > /dev/null
    sudo apt-get update
  fi
}

jq_replace_file() {
  input_file="${@: -1}"
  tmpfile=$(mktemp -p $(dirname "$input_file"))
  jq "$@" > "$tmpfile" && mv "$tmpfile" "$input_file"
  rm -f "$tmpfile"
}

key_path=/etc/apt/keyrings/packages.microsoft.asc

install_deb_packages curl apt-transport-https
install_apt_key https://packages.microsoft.com/keys/microsoft.asc "$key_path"
add_apt_list "deb [arch=$(dpkg --print-architecture) signed-by=$key_path] https://packages.microsoft.com/repos/code stable main" /etc/apt/sources.list.d/vscode.list
install_deb_packages code
install_extensions $extensions

#uninstall_extensions $extensions
