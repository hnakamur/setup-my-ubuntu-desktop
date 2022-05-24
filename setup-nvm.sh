#!/bin/bash
set -eu
if ! type nvm >& /dev/null; then
  repo_url=https://github.com/nvm-sh/nvm
  version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
  curl -sSo- https://raw.githubusercontent.com/nvm-sh/nvm/$version/install.sh | bash
fi
