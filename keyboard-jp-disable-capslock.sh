#!/bin/bash
sudo sed -i -e '/^XKBMODEL=/s/".*/"pc105"/;/^XKBLAYOUT=/s/".*/"jp"/;/^XKBOPTIONS=/s/".*/"ctrl:nocaps"/' /etc/default/keyboard
