#!/bin/bash
if [ ! -f /etc/systemd/system/iptables-for-lxd-with-docker.service ]; then
  cat <<'EOF' | sudo tee /etc/systemd/system/iptables-for-lxd-with-docker.service > /dev/null
[Unit]
Description=Add iptables rules for LXD coexisting with Docker
After=docker.service

[Service]
Type=oneshot
# https://discuss.linuxcontainers.org/t/lxd-and-docker-firewall-redux-how-to-deal-with-forward-policy-set-to-drop/9953/7
ExecStart=iptables -I FORWARD -o lxdbr0 -m comment --comment "generated for LXD network lxdbr0" -j ACCEPT
ExecStart=iptables -I FORWARD 2 -i lxdbr0 -m comment --comment "generated for LXD network lxdbr0" -j ACCEPT

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
fi

if [ $(systemctl is-enabled iptables-for-lxd-with-docker) != enabled ]; then
  sudo systemctl enable --now iptables-for-lxd-with-docker
fi
