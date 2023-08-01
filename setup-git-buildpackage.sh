#!/bin/bash
set -eu

sudo apt install -y git-buildpackage quilt debootstrap devscripts dput debhelper

if ! grep dquilt ~/.bash_aliases; then
  cat >> ~/.bash_aliases <<'EOF'

alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion -o filenames dquilt
EOF
fi

if [ ! -f ~/.quiltrc-dpkg ]; then
  cat > ~/.quiltrc-dpkg <<'EOF'
d=. ; while [ ! -d $d/debian -a `readlink -e $d` != / ]; do d=$d/..; done
if [ -d $d/debian ] && [ -z $QUILT_PATCHES ]; then
    # if in Debian packaging tree with unset $QUILT_PATCHES
    QUILT_PATCHES="debian/patches"
    QUILT_PATCH_OPTS="--reject-format=unified"
    QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
    QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
    QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"
    if ! [ -d $d/debian/patches ]; then mkdir $d/debian/patches; fi
fi
EOF
fi

if [ ! -x ~/.local/bin/gpg-passphrase ]; then
  mkdir -p ~/.local/bin
  cat > ~/.local/bin/gpg-passphrase <<'EOF'
#!/bin/sh
exec <$HOME/.gpg-passphrase /usr/bin/gpg --batch --pinentry-mode loopback --passphrase-fd 0 "$@"
EOF
  chmod +x ~/.local/bin/gpg-passphrase
fi

if [ ! -f ~/.gpg-passphrase ]; then
  read -s -p "GPG passphrase: " passphrase
  echo "$passphrase" >> ~/.gpg-passphrase
  chmod 400 ~/.gpg-passphrase
fi
