#!/bin/bash
set -ev
shopt -s dotglob

# Languages: ballerina, bash, c, common lisp, clojure, cpp, cpp11, crystal, csharp, dart, elisp, elixir, enzyme, erlang, express, flow, forth, fsharp, gatsbyjs, go, guile, haskell, java, jest, julia, kotlin, love2d, lua, nextjs, nim, nodejs, ocaml, pascal, php, python3, pygame, python, pyxel, quil, raku, react_native, reactjs, reactts, rlang, ruby, rust, scala, sqlite, swift, tcl, WebAssembly


apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 09617FD37CC06B54

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 6494C6D6997C215E

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61



add-apt-repository -y 'deb https://dist.crystal-lang.org/apt crystal main'

add-apt-repository -y 'deb https://download.mono-project.com/repo/ubuntu stable-bionic main'

add-apt-repository -y 'deb [arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'

add-apt-repository -y 'ppa:kelleyk/emacs'

add-apt-repository -y 'ppa:longsleep/golang-backports'

add-apt-repository -y 'ppa:bartbes/love-stable'

add-apt-repository -y 'ppa:avsm/ppa'

add-apt-repository -y 'ppa:deadsnakes/ppa'

add-apt-repository -y 'deb https://dl.bintray.com/nxadm/rakudo-pkg-debs bionic main'


apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales unzip curl wget git subversion mercurial gnupg build-essential vim ca-certificates chromium-chromedriver man rlwrap valgrind libc6-dbg busybox software-properties-common apt-utils dirmngr gpg-agent x11vnc xserver-xorg-video-dummy x11-xserver-utils cmake ninja-build silversearcher-ag ssh redis-tools libboost-all-dev golang-go clang-7 clang-format-7 sbcl openjdk-11-jre-headless libssl-dev crystal mono-complete dart=2.6.0-1 emacs26 sqlite3 erlang elixir erlang-ic gforth fsharp pkg-config guile-2.2 ghc maven openjdk-11-jdk love lua5.1 liblua5.1-0 liblua5.1-bitop0 lua-socket luarocks nim m4 ocaml opam fpc php-cli php-pear python3.8 python3.8-dev python3.8-tk python3.8-venv libtk8.6 libevent-dev gcc tk-dev libsdl-ttf2.0-dev libportmidi-dev libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic fontconfig fonts-freefont-ttf libfreetype6-dev python-pip python-wheel python-dev python-tk libglfw3-dev portaudio19-dev libsdl2-image-2.0-0 rakudo-pkg r-base r-base-dev r-recommended littler r-cran-littler r-cran-stringr rake-compiler ruby-dev ruby rubygems-integration rubygems rust-gdb libedit2 python2.7-minimal libpython2.7 libxml2 clang libicu-dev tcl8.6 tklib tcllib tcl-dev || exit 1

update-ca-certificates

curl -sL https://deb.nodesource.com/setup_10.x | bash -
DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
npm install -g yarn

cd /home/runner
mkdir -p /opt/homes/default
mkdir -p /opt/virtualenvs
mv -nt /opt/homes/default/ $(ls -A /home/runner)

curl https://xpra.org/xorg.conf > /opt/xorg.conf

rm -rf /var/lib/apt/lists/*
rm /phase1.sh
