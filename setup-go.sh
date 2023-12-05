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
  if [ "$1" == "--user" ]; then
    rm -rf $HOME/.local/go
    curl -L "$tarball_url" | tar -zx -C $HOME/.local
  
    if ! grep -q -F $HOME/.local/go $HOME/.profile; then
      cat >> $HOME/.profile <<'EOF'

if [ -d "$HOME/.local/go/bin" ] ; then
    PATH="$HOME/.local/go/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi
EOF
    fi
  else
    sudo rm -rf /usr/local/go
    curl -L "$tarball_url" | sudo tar -zx -C /usr/local
  
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
fi

