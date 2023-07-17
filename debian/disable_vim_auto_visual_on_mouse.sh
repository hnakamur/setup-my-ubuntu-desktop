#!/bin/sh
if ! grep -q "^set mouse-=a$" $HOME/.vimrc 2>/dev/null; then
  echo "set mouse-=a" >> $HOME/.vimrc
fi
