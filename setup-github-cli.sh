#!/bin/bash
set -eu
sudo apt install -y curl

repo_url=https://github.com/cli/cli
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's|^v||')

deb_path=/tmp/gh_${version}_linux_amd64.deb
curl -L -o ${deb_path} ${repo_url}/releases/download/v${version}/gh_${version}_linux_amd64.deb
sudo apt install -y $deb_path
