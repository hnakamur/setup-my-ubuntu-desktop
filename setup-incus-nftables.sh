#!/bin/bash
set -eu
# Add nftables rules for runngin Incus with Docker
#
# See https://hnakamur.github.io/blog/2022/06/18/adjust-iptables-for-lxd-and-docker/
#
# The nftables rules are translated with the following commands:
# $ /usr/sbin/iptables-translate -I FORWARD -o incusbr0 -m comment --comment "generated for Incus network incusbr0" -j ACCEPT
# nft 'insert rule ip filter FORWARD oifname "incusbr0" counter accept comment "generated for Incus network incusbr0"'
# $ /usr/sbin/iptables-translate -I FORWARD 2 -i incusbr0 -m comment --comment "generated for Incus network incusbr0" -j ACCEPT
# nft 'insert rule ip filter FORWARD iifname "incusbr0" counter accept comment "generated for Incus network incusbr0"'

unitfile=/etc/systemd/system/nftables-for-incus-with-docker.service
servicename=$(basename "$unitfile")

if [ ! -f "$unitfile" ]; then
  cat <<EOF | sudo tee "$unitfile" >/dev/null
[Unit]
Description=Add iptables rules for LXD coexisting with Docker
After=docker.service

[Service]
Type=oneshot

ExecStart=nft insert rule ip filter FORWARD oifname "incusbr0" counter accept comment \"generated for Incus network incusbr0\"
ExecStart=nft insert rule ip filter FORWARD iifname "incusbr0" counter accept comment \"generated for Incus network incusbr0\"

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl start "$servicename"
  sudo systemctl enable "$servicename"
fi
