#!/bin/bash
set -eu

repo_url=https://github.com/keepassxreboot/keepassxc

install_fuse() {
  sudo apt install -y fuse libfuse2
  sudo modprobe fuse
  getent group fuse || sudo groupadd fuse
  sudo usermod -a -G fuse "$USER"
}

install_fuse
sudo apt install -y curl

version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')

app_path="$HOME/AppImage/KeePassXC-${version}-x86_64.AppImage"
if [ -x "$app_path" ]; then
  echo KeePassXC latest version $version is already installed.
else
  mkdir -p $(dirname "$app_path")
  app_filename=$(basename "$app_path")
  curl -Lo "$app_path" ${repo_url}/releases/download/${version}/${app_filename}
  chmod +x "$app_path"
  echo Downloaded KeePassXC latest version ($version).
fi

icon_path="$HOME/.icons/keepassxc-logo.svg"
if [ ! -f "$icon_path" ]; then
  mkdir -p $(dirname "$icon_path")
  curl -L -o "$icon_path" https://keepassxc.org/images/keepassxc-logo.svg
fi

desktop_path=$HOME/.local/share/applications/keepassxc.desktop
if ! grep -q "^Exec=$HOME/AppImage/KeePassXC-${version}-x86_64.AppImage$" "$desktop_path"; then
  mkdir -p $(dirname "$desktop_path")
  cat > "$desktop_path" <<EOF
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=$HOME/AppImage/KeePassXC-${version}-x86_64.AppImage
Name=KeepassXC
Comment=Cross-Platform Password Manager
Icon=keepassxc-logo
EOF
  echo Created or updated desktop file for KeePassXC.
fi
