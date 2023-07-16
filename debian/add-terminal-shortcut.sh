#!/bin/sh
# add-terminal-shorcut.sh
#
# Add keyboard shortcut to open GNOME terminal.
# NOTE: Added shortcus become listed in GNOME settings GUI after you logout and login again.

old_keys="$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)"

# Get the least unused id.
id=$(echo "$old_keys" | awk -F', ' '{
  for (i = 1; i <= NF; i++) {
    sub(/\[?'\''\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\/custom/, "", $i)
    sub(/\/'\'']?/, "", $i)
    ids[$i] = 1
  }
}
END {
  for (i = 0; i <= NF; i++) {
    if (ids[i] != 1) {
      print i
      break
    }
  }
}')

key=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${id}/
if [ "$old_keys" = "@as []" ]; then
  new_keys="['$key']"
else
  new_keys=$(echo "$old_keys" | sed "s|]|, '$key']|")
fi

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$new_keys"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key name 'Open Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key command gnome-terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$key binding '<Ctrl><Alt>t'
