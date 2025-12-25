#!/bin/bash
set -eu
repo_url=https://github.com/go-task/task

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl bash-completion
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/v||')
installed_version=$(task --version 2>/dev/null || :)
if [ "$installed_version" != "$version" ]; then
  work_dir=/tmp/task_work.$$
  bin_dir=$HOME/.local/bin
  bash_completions_dir="$HOME/.local/share/bash-completion/completions"
  bash_completions_dir_no_expand='$HOME/.local/share/bash-completion/completions'

  mkdir -p "$work_dir"
  arch=$(dpkg --print-architecture)
  curl -sSL ${repo_url}/releases/download/v${version}/task_linux_${arch}.tar.gz | tar zx -C "$work_dir"
  install -d "$bin_dir" "$bash_completions_dir"
  install "$work_dir/task" "$bin_dir"
  install "$work_dir/completion/bash/task.bash" "$bash_completions_dir"
  rm -rf "$work_dir"

  if ! grep -q -F "source $bash_completions_dir_no_expand/task.bash" $HOME/.bashrc; then
    echo "source $bash_completions_dir_no_expand/task.bash" >> $HOME/.bashrc
  fi
fi
