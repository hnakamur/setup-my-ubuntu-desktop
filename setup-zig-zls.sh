#!/bin/bash
set -eu

# install zig master
tarball_url=$(curl -sS https://ziglang.org/download/ | grep -o -E 'https://ziglang\.org/builds/zig-linux-x86_64-[^>]+')
master_version=$(echo "$tarball_url" | grep -o -E '[0-9.]+-dev\.[0-9]+\+[0-9a-f]+')
dest_dir="$HOME/zig/zig-$master_version"
if [ ! -d "$dest_dir" ]; then
  curl -L "$tarball_url" | tar --one-top-level="$dest_dir" --strip-components=1 -xJf -
  echo "Downloaded zig and extracted to $dest_dir."
fi

# create symbolic link for zig master directory
src_dir="$HOME/zig/zig-master"
if [ "$(readlink -f $src_dir)" != "$dest_dir" ]; then
  dest_path=$(basename "$dest_dir")
  rm -f "$src_dir"
  ln -s "$dest_path" "$src_dir"
  echo "Created or updated symbolic link $src_dir -> $dest_path"
fi

# build and install zls
zls_path="$HOME/zls/zls"
if [ ! -x "$zls_path" ]; then
  master_zig="$dest_dir/zig"
  ghq get https://github.com/zigtools/zls
  cd $HOME/ghq/github.com/zigtools/zls
  "$master_zig" build -Drelease-safe

  zls_dir=$(dirname "$zls_path")
  mkdir -p "$zls_dir"
  install ./zig-out/bin/zls "$zls_dir"
fi

# create zls config if not exist
if [ ! -f "$HOME/.config/zls.json" ]; then
  "$zls_path" config
fi
