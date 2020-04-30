#!/bin/bash
set -ev
shopt -s dotglob

groupadd -g 1000 runner
useradd -m -d /home/runner -g runner -s /bin/bash runner --uid 1000 --gid 1000

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales unzip curl wget git subversion mercurial gnupg build-essential vim ca-certificates chromium-chromedriver man rlwrap valgrind libc6-dbg busybox software-properties-common apt-utils dirmngr gpg-agent x11vnc xserver-xorg-video-dummy x11-xserver-utils cmake ninja-build silversearcher-ag ssh redis-tools libboost-all-dev golang-go

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

mkdir /config
chown runner.runner /config

rm -rf /var/lib/apt/lists/*
rm /phase0.sh
