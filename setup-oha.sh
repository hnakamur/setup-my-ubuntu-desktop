#!/bin/bash
set -eu
repo_url=https://github.com/hatoo/oha
dest_path="$HOME/.local/bin/oha"
if [ ! -x "$dest_path" ]; then
  version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
  mkdir -p $(dirname "$dest_path")
  curl -sSLo "$dest_path" ${repo_url}/releases/download/${version}/oha-linux-amd64-pgo
  chmod +x "$dest_path"
fi
