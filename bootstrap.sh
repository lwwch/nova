#!/bin/bash
###########

create_dirs() {

  echo "creating dirs..."

  mkdir -p ~/projects
  mkdir -p ~/software

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

  echo "installing local configs..."

  cp vimrc ~/.vimrc
  cp bashrc ~/.bashrc
  cp tmux.conf ~/.tmux.conf

  mkdir -p ~/.vim/colors
  cp vim/colors/* ~/.vim/colors

}

install_conda() {

  echo "installing conda env..."

  pushd ~/software
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

}

create_dirs
install_packages
install_local_configs
install_conda

