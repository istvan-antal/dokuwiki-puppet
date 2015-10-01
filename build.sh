#!/bin/bash
sudo apt-get install --assume-yes puppet make
cd "$(dirname ${BASH_SOURCE[0]})"
sudo puppet apply --modulepath=./modules main.pp