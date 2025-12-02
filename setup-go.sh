#!/bin/bash
set -eu

user=0

case "${1:-}" in
--user)
  user=1
  ;;
esac

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

add_prepend_path_function() {
  file="$1"

  if ! grep -qF 'prepend_path()' "$file"; then
    cat <<'EOF' >> "$file"
prepend_path() {
  dir="$1"

  case ":${PATH}:" in
    *:"$dir":*)
      ;;
    *)
      if [ -d "$dir" ]; then
        PATH="$dir:$PATH"
      fi
      export PATH
      ;;
  esac
}

EOF
  fi
}

add_append_path_function() {
  file="$1"

  if ! grep -qF 'append_path()' "$file"; then
    cat <<'EOF' >> "$file"
append_path() {
  dir="$1"

  case ":${PATH}:" in
    *:"$dir":*)
      ;;
    *)
      if [ -d "$dir" ]; then
        PATH="$PATH:$dir"
      fi
      export PATH
      ;;
  esac
}

EOF
  fi
}

prepend_path() {
  file="$1"
  shift
  paths="$@"

  for path in $paths; do
    if ! grep -qF 'prepend_path "'"$path"'"' "$file"; then
      echo 'prepend_path "'"$path"'"' >> "$file"
    fi
  done
}

install_deb_packages curl jq

versions_json=$(curl -sS 'https://go.dev/dl/?mode=json')
latest_version=$(echo "$versions_json" | jq -r '.[0].version')
if [ "$user" -eq 1 ]; then
  installed_version=$($HOME/.local/go/bin/go version 2>/dev/null | cut -d ' ' -f 3 || :)
else
  installed_version=$(/usr/local/go/bin/go version 2>/dev/null | cut -d ' ' -f 3 || :)
fi
if [ "$installed_version" != "$latest_version" ]; then
  filename=$(echo "$versions_json" | jq -r '.[0].files|map(select(.os=="linux" and .arch=="amd64"))[0].filename')
  tarball_url="https://go.dev/dl/$filename"
  if [ "$user" -eq 1 ]; then
    rm -rf $HOME/.local/go
    curl -L "$tarball_url" | tar -zx -C $HOME/.local
  else
    sudo rm -rf /usr/local/go
    curl -L "$tarball_url" | sudo tar -zx -C /usr/local
  fi
fi

if [ "$user" -eq 1 ]; then
  add_prepend_path_function $HOME/.profile
  add_append_path_function $HOME/.profile
  prepend_path $HOME/.profile '$HOME/.local/go/bin' '$HOME/go/bin'
else 
  add_prepend_path_function $HOME/.profile
  add_append_path_function $HOME/.profile
  prepend_path $HOME/.profile '/usr/local/go/bin' '$HOME/go/bin'
fi
