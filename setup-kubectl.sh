#!/bin/bash
set -eu

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

destpath="$HOME/.local/bin/kubectl"

installed_ver=$(kubectl version 2>/dev/null | head -1 | awk -F ': ' '{printf("%s", $2)}')
latest_ver=$(curl -sSfL -s https://dl.k8s.io/release/stable.txt)
if [ "$installed_ver" != "$latest_ver" ]; then
  #mkdir -p $(dirname "$destpath"
  curl -sSfLo "$destpath" --create-dirs "https://dl.k8s.io/release/$latest_ver/bin/linux/amd64/kubectl"
  chmod +x "$destpath"
fi
