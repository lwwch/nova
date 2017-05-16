#!/bin/bash
###########
#
#   bootstraps dev env from fresh / blank Ubuntu install
#

set -e

DISTRO=$(lsb_release -i -s)
VERSION=$(lsb_release -r -s)
[ "$DISTRO" != "Ubuntu" ] && (echo "ERROR: boostrap only for Ubuntu." && exit 1)

case $VERSION in
    16.04)
        echo "installing for ubuntu 16.04 xenial"
        ;;
    14.04)
        echo "installing for ubuntu 14.04 trusty"
        ;;
    12.04)
        echo "warning, unsupported ubuntu 12.04 precise"
        ;;
    *)
        echo "unknown ubuntu release, this may go poorly..."
        ;;
esac

#
#   to bootstrap, just install the packages in the list then
#   hand control over to the more sophisticated python script
#

REPO=${HOME}/devenv
if [ -d $REPO ]; then
    echo "repo exists, updating"
    cd $REPO
    git pull --rebase
else
    echo "bootstrapping repo..."
    sudo apt-get install -y git
    git clone https://github.com/hathcock/devenv.git ${REPO}
fi

echo "bootstrapping packages..."
cd ${REPO}
sudo apt-get install -y $(grep -vE "^#" ./packages)

echo "setting global permissions for font dirs..."
sudo chmod a+w /usr/local/share/fonts

echo "installing secondary files..."
if [ ! -d ${HOME}/.vim/bundle ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

SCRIPT=$(readlink -f ./devenv.py)
PYTHON=$(which python3)
[ "$PYTHON" == "" ] && (echo "cannot find python3" && exit 1)

echo "packages installed. handing over to python script ${SCRIPT}"
sudo $PYTHON $SCRIPT
