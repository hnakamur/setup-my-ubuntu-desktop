setup-my-ubuntu-desktop
=======================

Scripts to set up my Ubuntu desktop.

The current target is Ubuntu 22.04 with ZFS root partition.

```
sudo apt update
sudo apt install -y curl jq
```

```
./enable-apt-deb-src.sh
./swap-capslock-ctrl.sh
./setup-mozc.sh
sudo systemctl reboot
```

```
./setup-keepassxc.sh
./setup-google-chrome.sh
./setup-vim.sh
./setup-ghq.sh
./setup-github-cli.sh
./setup-github-hub.sh
./setup-ripgrep.sh
```

```
./setup-go.sh
PATH=/usr/local/go/bin:$PATH ./setup-vgrep.sh
exec $SHELL -l
```

```
./setup-lxd.sh
```

## setup gpg

Export gpg secret keys on my another Ubuntu machine with:
```
gpg --export-secret-keys > my-gpg-secret-keys
```
Input my passphrase.

Copy it to my new machine.
Copy my passphrase using KeePassXC and import my secret keys with:
```
gpg --import my-gpg-secret-keys
```
Paste my passphrase in the modal dialog.

```
if ! grep DEBFULLNAME ~/.profile; then
cat >> ~/.profile <<'EOF'

# http://manpages.ubuntu.com/manpages/precise/en/man1/dch.1.html
DEBFULLNAME="Hiroaki Nakamura"
DEBEMAIL="hnakamur@gmail.com"

# https://askubuntu.com/questions/186329/how-to-automate-the-pass-phrases-when-gpg-signing-dpkg-buildpackage
GPGKEY=0x1DFBC664
EOF
fi
```

## setup environments for building deb packages at Ubuntu PPA (Personal Package Archives)

```
./setup-ubuntu-src-pkg-downloader.sh
./setup-ppa-files-downloader.sh
./setup-git-buildpackage.sh
./setup-sbuild.sh
```

## setup environments for building RPMs at Fedora Copr

```
setup-copr-files-downloader.sh
```

## Add bookmark for searching with Google English to Firefox

Name: Google en
URL: https://www.google.co.jp/search?q=%s&hl=en
Keyword: g

## Uninstall snap Firefox and install Mozilla's official Firefox pacakge

```
sudo snap remove firefox
```

```
./setup-firefox-official-package.sh
