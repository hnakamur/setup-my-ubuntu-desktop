#!/bin/bash
sudo sed -i -e '/^XKBMODEL=/s/".*/"pc101"/;/^XKBLAYOUT=/s/".*/"us"/;/^XKBOPTIONS=/s/""/"ctrl:swapcaps"/' /etc/default/keyboard
