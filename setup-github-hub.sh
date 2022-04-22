#!/bin/bash
set -eu
sudo apt install -y curl

repo_url=https://github.com/github/hub
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's|^v||')

mkdir -p ~/.local/bin
curl -L ${repo_url}/releases/download/v${version}/hub-linux-amd64-${version}.tgz | tar -C ~/.local/bin/ --strip-components=2 -zxf - hub-linux-amd64-${version}/bin/hub 
