#!/bin/bash
sudo apt install -y curl

url_path=$(curl -sS https://go.dev/dl/ | grep linux-amd64.tar.gz | head -1 | sed 's/.*href="//;s/">//')
tgz_path=/tmp/$(basename $url_path)
curl -L -o $tgz_path https://go.dev${url_path}
sudo rm -rf /usr/local/go
sudo tar -zxf $tgz_path -C /usr/local/

if ! grep -F '/usr/local/go' ~/.profile; then
  cat >> ~/.profile <<'EOF'

# set PATH so it includes /usr/local/go/bin if it exists
if [ -d "/usr/local/go/bin" ] ; then
    PATH="/usr/local/go/bin:$PATH"
fi

# set PATH so it includes user's private go/bin if it exists
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi
EOF
fi
