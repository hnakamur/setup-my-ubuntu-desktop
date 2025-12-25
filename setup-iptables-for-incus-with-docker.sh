#!/bin/bash
if [ ! -f /etc/systemd/system/iptables-for-incus-with-docker.service ]; then
  cat <<'EOF' | sudo tee /etc/systemd/system/iptables-for-incus-with-docker.service > /dev/null
[Unit]
Description=Add iptables rules for Incus coexisting with Docker
After=docker.service

[Service]
Type=oneshot
# https://discuss.linuxcontainers.org/t/incus-and-docker-firewall-redux-how-to-deal-with-forward-policy-set-to-drop/9953/7
ExecStart=iptables -I FORWARD -o incusbr0 -m comment --comment "generated for Incus network incusbr0" -j ACCEPT
ExecStart=iptables -I FORWARD 2 -i incusbr0 -m comment --comment "generated for Incus network incusbr0" -j ACCEPT

[Install]
WantedBy=multi-user.target
EOF
  sudo systemctl daemon-reload
fi

if [ $(systemctl is-enabled iptables-for-incus-with-docker) != enabled ]; then
  sudo systemctl enable --now iptables-for-incus-with-docker
fi
