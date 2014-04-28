#!/usr/bin/env bash

echo ">>> Installing Base Packages"

# Install base packages
sudo apt-get install -y unzip git-core ack-grep vim tmux curl wget

# Common fixes for git
git config --global http.postBuffer 65536000

# Cache http credentials for one day while pull/push
git config --global credential.helper 'cache --timeout=86400'
