setup-my-ubuntu-desktop
=======================

Scripts to set up my Ubuntu desktop.

The current target is Ubuntu 22.04 with ZFS root partition.


```
./swap-capslock-ctrl.sh
./setup-mozc.sh
sudo systemctl reboot
```

```
./setup-keepassxc.sh
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

## Add bookmark for searching with Google English to Firefox

Name: Google en
URL: https://www.google.co.jp/search?q=%s&hl=en
Keyword: g
