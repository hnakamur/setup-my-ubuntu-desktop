#!/bin/bash
set -eu

extensions="
  golang.go
  tiehuis.zig
  AugusteRame.zls-vscode
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
    key_temp_filename=$(mktemp)
    curl -sS "$key_url" | gpg --dearmor > "$key_temp_filename"
    sudo install -o root -g root -m 644 "$key_temp_filename" "$key_path"
    rm -f "$key_temp_filename"
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

key_path=/etc/apt/trusted.gpg.d/packages.microsoft.gpg

install_deb_packages curl gpg apt-transport-https
install_apt_key https://packages.microsoft.com/keys/microsoft.asc "$key_path"
add_apt_list "deb [arch=amd64,arm64,armhf signed-by=$key_path] https://packages.microsoft.com/repos/code stable main" /etc/apt/sources.list.d/vscode.list
install_deb_packages code
install_extensions $extensions

#uninstall_extensions $extensions

zls_path="$HOME/zls/zls"

user_config_path="$HOME/.config/Code/User/settings.json"
[ -f "$user_config_path" ] || echo '{}' > "$user_config_path"
jq_replace_file '."zigLanguageClient.path" |= "'"$zls_path"'" |
  setpath(["[zig]", "editor.defaultFormatter"]; "tiehuis.zig") |
  ."zig.buildOnSave" |= true
  ' "$user_config_path"
