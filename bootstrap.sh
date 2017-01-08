#!/bin/bash
###########

create_dirs() {

  echo "creating dirs..."

  mkdir -p ~/projects
  mkdir -p ~/third_party

}

install_packages() {

  echo "installing system packages..."

  sudo apt-get install -y \
    build-essential \
    clang \
    tmux \
    vim \
    vim-gtk \
    chromium-browser

}

install_local_configs() {

  echo "concating local configs..."

  cat vimrc >> ~/.vimrc
  cat bashrc >> ~/.bashrc
  cat tmux.conf >> ~/.tmux.conf

  mkdir -p ~/.vim/colors
  cp vim/colors/* ~/.vim/colors

}

install_conda() {

  echo "installing conda env..."

  pushd ~/third_party
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

}

create_dirs
install_packages
install_local_configs
install_conda

