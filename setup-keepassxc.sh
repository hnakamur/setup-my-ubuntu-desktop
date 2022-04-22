#!/bin/bash
set -eu

repo_url=https://github.com/keepassxreboot/keepassxc

install_fuse() {
sudo apt install -y fuse libfuse2
sudo modprobe fuse
sudo groupadd fuse
sudo usermod -a -G fuse "$USER"
}

install_fuse
sudo apt install -y curl

version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')

mkdir -p ~/AppImage
cd ~/AppImage
curl -LO ${repo_url}/releases/download/${version}/KeePassXC-${version}-x86_64.AppImage
chmod +x KeePassXC-${version}-x86_64.AppImage

mkdir -p ~/.icons ~/.local/share/applications
(cd ~/.icons; curl -LO https://keepassxc.org/images/keepassxc-logo.svg)

cat > ~/.local/share/applications/keepassxc.desktop <<EOF
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=${version}
Type=Application
Terminal=false
Exec=/home/hnakamur/AppImage/KeePassXC-${version}-x86_64.AppImage
Name=KeepassXC
Comment=Cross-Platform Password Manager
Icon=keepassxc-logo
EOF
