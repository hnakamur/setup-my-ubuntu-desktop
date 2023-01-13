#!/bin/bash
sudo sed -i -e '/^XKBMODEL=/s/".*/"pc105"/;/^XKBLAYOUT=/s/".*/"us"/;/^XKBOPTIONS=/s/""/"ctrl:swapcaps"/' /etc/default/keyboard
