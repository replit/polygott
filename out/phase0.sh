#!/bin/bash
set -ev
shopt -s dotglob

groupadd -g 1000 runner
useradd -m -d /home/runner -g runner -s /bin/bash runner --uid 1000 --gid 1000

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils build-essential busybox ca-certificates chromium-chromedriver cmake curl dirmngr ffmpeg firefox-geckodriver fluxbox git gnupg gnuplot-qt golang-go gpg-agent jq libboost-all-dev libc6-dbg libopus0 libopusfile0 libsdl-dev libsdl2-dev locales man mercurial mesa-utils ninja-build pulseaudio redis-tools rlwrap rsync silversearcher-ag software-properties-common ssh subversion tigervnc-standalone-server unzip valgrind vim wget x11-apps

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
update-ca-certificates

wget -nv \
  https://launchpad.net/ubuntu/+archive/primary/+files/libtinfo6_6.1+20181013-2ubuntu2_amd64.deb \
  https://launchpad.net/ubuntu/+archive/primary/+files/libreadline8_8.0-1_amd64.deb \
  https://storage.googleapis.com/container-bins/stderred_1.0_amd64.deb
dpkg -i *.deb
rm *.deb

mkdir -p /config /opt/homes/default /opt/virtualenvs
rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/default
chown runner:runner -R /home/runner /opt/homes/default /config /opt/virtualenvs

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 09617FD37CC06B54
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 6494C6D6997C215E
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 6507444DBDF4EAD2
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61


curl -L https://packagecloud.io/cs50/repo/gpgkey | apt-key add -

curl -L https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -

curl -L https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

add-apt-repository --yes --no-update 'deb https://packagecloud.io/cs50/repo/ubuntu/ bionic main'
add-apt-repository --yes --no-update 'deb https://dist.crystal-lang.org/apt crystal main'
add-apt-repository --yes --no-update 'deb https://download.mono-project.com/repo/ubuntu stable-bionic main'
add-apt-repository --yes --no-update 'deb [arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'
add-apt-repository --yes --no-update ppa:kelleyk/emacs
add-apt-repository --yes --no-update 'deb https://packages.erlang-solutions.com/ubuntu bionic contrib'
add-apt-repository --yes --no-update 'deb https://deb.nodesource.com/node_10.x bionic main'
add-apt-repository --yes --no-update ppa:haxe/releases
add-apt-repository --yes --no-update ppa:bartbes/love-stable
add-apt-repository --yes --no-update 'deb http://dl.mercurylang.org/deb/ stretch main'
add-apt-repository --yes --no-update ppa:avsm/ppa
add-apt-repository --yes --no-update ppa:deadsnakes/ppa
add-apt-repository --yes --no-update 'deb https://dl.bintray.com/nxadm/rakudo-pkg-debs bionic main'

rm -rf /var/lib/apt/lists/*

rm /phase0.sh
