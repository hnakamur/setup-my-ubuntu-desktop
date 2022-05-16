#!/bin/bash
conf_filename=/etc/security/limits.d/core-unlimited.conf

if [ ! -f "$conf_filename" ]; then
    cat <<'EOF' | sudo tee "$conf_filename" > /dev/null
root soft core unlimited
root hard core unlimited
* soft core unlimited
* hard core unlimited
EOF
fi

if grep -qxF 'enabled=1' /etc/default/apport; then
    sudo sed -i 's/^enabled=1$/enabled=0/' /etc/default/apport
fi
