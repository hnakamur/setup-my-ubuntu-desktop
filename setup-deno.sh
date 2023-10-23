#!/bin/bash
set -eu

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if ! type deno >& /dev/null; then
  install_deb_packages curl
  curl -fsSL https://deno.land/x/install/install.sh | sh

cat <<'EOF' >> ~/.bashrc

# Deno
export DENO_INSTALL="/home/hnakamur/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
EOF
fi
