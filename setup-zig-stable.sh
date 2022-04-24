#!/bin/bash
if [ $# -ne 1 ]; then
  cat >&2 <<EOF
Usage: $0 version
EOF
  exit 2
fi

version="$1"

tarball_url="https://ziglang.org/download/${version}/zig-linux-x86_64-${version}.tar.xz"
dest_dir="$HOME/zig/zig-$version"
if [ ! -d "$dest_dir" ]; then
  curl -L "$tarball_url" | tar --one-top-level="$dest_dir" --strip-components=1 -xJf -
  echo "Downloaded zig and extracted to $dest_dir."
fi

src_zig_path="$HOME/.local/bin/zig"
dest_zig_path="$dest_dir/zig"
if [ "$(readlink -f $src_zig_path)" != "$dest_zig_path" ]; then
  rm -f "$src_zig_path"
  ln -s "$dest_zig_path" "$src_zig_path"
  echo "Created or updated symbolic link $src_zig_path -> $dest_zig_path"
fi
