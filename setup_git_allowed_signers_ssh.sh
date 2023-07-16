#!/bin/sh
allowed_signers_path=$HOME/.config/git/allowed_signers

if [ ! -f "$allowed_signers_path" ]; then
  mkdir -p "$(dirname $allowed_signers_path)"
  echo "$(git config --get user.email) namespaces=\"git\" $(git config --get user.signingkey | cut -d ' ' -f -2)" > "$allowed_signers_path"
fi
