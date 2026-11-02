#!/usr/bin/bash

set -eux

apt-get update
apt-get install -yy grub-common grub-efi-amd64-bin zip
