#!/bin/bash
install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl jq

versions_json=$(curl -sS 'https://go.dev/dl/?mode=json')
latest_version=$(echo "$versions_json" | jq -r '.[0].version')
installed_version=$(go version 2>/dev/null | cut -d ' ' -f 3 || :)
if [ "$installed_version" != "$latest_version" ]; then
  filename=$(echo "$versions_json" | jq -r '.[0].files|map(select(.os=="linux" and .arch=="amd64"))[0].filename')
  tarball_url="https://go.dev/dl/$filename"
  local_path="/tmp/$filename"
  curl -L -o "$local_path" "$tarball_url"
  sudo rm -rf /usr/local/go
  sudo tar -zxf "$local_path" -C /usr/local/

  if ! grep -q -F /usr/local/go $HOME/.profile; then
    cat >> $HOME/.profile <<'EOF'

if [ -d "/usr/local/go/bin" ] ; then
    PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi
EOF
  fi
fi

