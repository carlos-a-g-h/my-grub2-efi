#!/usr/bin/bash

set -eux

sudo apt-get update
sudo apt-get install -yy grub-common grub-efi-amd64-bin zip
