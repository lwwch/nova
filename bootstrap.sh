#!/bin/bash

PYTHON_VERSION=3.6.7
THIRD="$HOME/third_party"

set -e

install_packages() {
  sudo apt-get install -y \
  git \
  vim \
  vim-gtk \
  tmux \
  cmake \
  build-essential \
  chromium-browser \
  curl \
  net-tools \
  neofetch \
  htop \
  ninja-build \
  yasm \
  libssl-dev \
  zlib1g-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  uuid-dev \
  python3-venv
}

bootstrap_dirs() {
  mkdir -p ~/projects
  mkdir -p $THIRD
}

bootstrap_vim() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "Will need to run :PlugInstall from inside vim"
}

install_pyenv() {
  python3 -m venv $THIRD/.pyenv
}

install_ripgrep() {
  pushd $THIRD
  if [ -e $THIRD/ripgrep-0.10.0-x86_64-unknown-linux-musl/rg ]; then
    echo "ripgrep exists"
    return
  fi

  wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
  tar -xvf ripgrep-0.10.0-x86_64-unknown-linux-musl.tar.gz
}

install_python_packages() {
  pip install -r requirements.txt
}

bootstrap_dirs
bootstrap_vim
install_packages
install_pyenv
install_ripgrep
install_python_packages
