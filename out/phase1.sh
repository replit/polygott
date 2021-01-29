#!/bin/bash
set -ev
shopt -s dotglob

# Languages: assembly, ballerina, bash, c, common lisp, clojure, cpp, cpp11, crystal, csharp, D, dart, deno, elisp, erlang, elixir, nodejs, enzyme, express, flow, forth, fortran, fsharp, gatsbyjs, go, guile, haskell, haxe, java, jest, julia, kotlin, love2d, lua, mercury, nextjs, nim, objective-c, ocaml, pascal, php, powershell, prolog, python3, pygame, python, pyxel, quil, raku, react_native, reactjs, reactts, rlang, ruby, rust, scala, sqlite, swift, tcl, WebAssembly, wren

if [[ -z "${LANGS}" || ",${LANGS}," == *",crystal,"* ]]; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 09617FD37CC06B54
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",csharp,"* || ",${LANGS}," == *",fsharp,"* ]]; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",dart,"* ]]; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 6494C6D6997C215E
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",mercury,"* ]]; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 6507444DBDF4EAD2
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",raku,"* ]]; then
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
fi


if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	curl -L https://packagecloud.io/cs50/repo/gpgkey | apt-key add -
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",elixir,"* || ",${LANGS}," == *",erlang,"* ]]; then
	curl -L https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",enzyme,"* || ",${LANGS}," == *",gatsbyjs,"* || ",${LANGS}," == *",jest,"* || ",${LANGS}," == *",nextjs,"* || ",${LANGS}," == *",nodejs,"* || ",${LANGS}," == *",react_native,"* || ",${LANGS}," == *",reactjs,"* || ",${LANGS}," == *",reactts,"* ]]; then
	curl -L https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	add-apt-repository -y 'deb https://packagecloud.io/cs50/repo/ubuntu/ bionic main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",crystal,"* ]]; then
	add-apt-repository -y 'deb https://dist.crystal-lang.org/apt crystal main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",csharp,"* || ",${LANGS}," == *",fsharp,"* ]]; then
	add-apt-repository -y 'deb https://download.mono-project.com/repo/ubuntu stable-bionic main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",dart,"* ]]; then
	add-apt-repository -y 'deb [arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elisp,"* ]]; then
	add-apt-repository -y ppa:kelleyk/emacs
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elixir,"* || ",${LANGS}," == *",erlang,"* ]]; then
	add-apt-repository -y 'deb https://packages.erlang-solutions.com/ubuntu bionic contrib'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",enzyme,"* || ",${LANGS}," == *",gatsbyjs,"* || ",${LANGS}," == *",jest,"* || ",${LANGS}," == *",nextjs,"* || ",${LANGS}," == *",nodejs,"* || ",${LANGS}," == *",react_native,"* || ",${LANGS}," == *",reactjs,"* || ",${LANGS}," == *",reactts,"* ]]; then
	add-apt-repository -y 'deb https://deb.nodesource.com/node_10.x bionic main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	add-apt-repository -y ppa:haxe/releases
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",love2d,"* ]]; then
	add-apt-repository -y ppa:bartbes/love-stable
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",mercury,"* ]]; then
	add-apt-repository -y 'deb http://dl.mercurylang.org/deb/ stretch main'
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ocaml,"* ]]; then
	add-apt-repository -y ppa:avsm/ppa
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	add-apt-repository -y ppa:deadsnakes/ppa
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",raku,"* ]]; then
	add-apt-repository -y 'deb https://dl.bintray.com/nxadm/rakudo-pkg-debs bionic main'
fi

packages=()
if [[ -z "${LANGS}" || ",${LANGS}," == *",assembly,"* ]]; then
	packages+=('nasm')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ballerina,"* ]]; then
	packages+=('openjdk-8-jdk')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	packages+=('clang-7')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	packages+=('clang-format-7')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	packages+=('libcs50')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",clisp,"* ]]; then
	packages+=('sbcl')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",clojure,"* ]]; then
	packages+=('openjdk-11-jre-headless')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",crystal,"* || ",${LANGS}," == *",raku,"* ]]; then
	packages+=('libssl-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",crystal,"* ]]; then
	packages+=('crystal')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",csharp,"* || ",${LANGS}," == *",fsharp,"* ]]; then
	packages+=('mono-complete')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",d,"* ]]; then
	packages+=('gdc')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",d,"* ]]; then
	packages+=('gdb')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",dart,"* ]]; then
	packages+=('dart=2.6.0-1')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elisp,"* ]]; then
	packages+=('emacs26')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elisp,"* || ",${LANGS}," == *",sqlite,"* ]]; then
	packages+=('sqlite3')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elixir,"* || ",${LANGS}," == *",erlang,"* ]]; then
	packages+=('esl-erlang')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",elixir,"* ]]; then
	packages+=('elixir')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",enzyme,"* || ",${LANGS}," == *",gatsbyjs,"* || ",${LANGS}," == *",jest,"* || ",${LANGS}," == *",nextjs,"* || ",${LANGS}," == *",nodejs,"* || ",${LANGS}," == *",react_native,"* || ",${LANGS}," == *",reactjs,"* || ",${LANGS}," == *",reactts,"* ]]; then
	packages+=('nodejs')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	packages+=('libtool-bin')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libffi-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	packages+=('automake')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* || ",${LANGS}," == *",ocaml,"* ]]; then
	packages+=('m4')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	packages+=('gforth')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	packages+=('gforth-lib')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	packages+=('gforth-common')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",fortran,"* ]]; then
	packages+=('gfortran')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",fsharp,"* ]]; then
	packages+=('fsharp')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",go,"* || ",${LANGS}," == *",tcl,"* ]]; then
	packages+=('pkg-config')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",guile,"* ]]; then
	packages+=('guile-2.2')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haskell,"* ]]; then
	packages+=('ghc')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('haxe')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libpng-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libturbojpeg-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libvorbis-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libopenal-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libmbedtls-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	packages+=('libuv1-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",java,"* ]]; then
	packages+=('maven')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",java,"* || ",${LANGS}," == *",kotlin,"* || ",${LANGS}," == *",scala,"* ]]; then
	packages+=('openjdk-11-jdk')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",love2d,"* ]]; then
	packages+=('love')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	packages+=('lua5.1')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	packages+=('liblua5.1-0')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	packages+=('liblua5.1-bitop0')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	packages+=('lua-socket')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	packages+=('luarocks')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",mercury,"* ]]; then
	packages+=('mercury-recommended')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",mercury,"* ]]; then
	packages+=('mercury-examples')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('clang-8')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libcairo-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('autoconf')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libblocksruntime-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libtiff-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libpthread-workqueue-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('libicu-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libgnutls28-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libjpeg-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libxft-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libtool')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libx11-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libxml2-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libxrandr-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libxt-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	packages+=('libkqueue-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ocaml,"* ]]; then
	packages+=('ocaml')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ocaml,"* ]]; then
	packages+=('opam')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pascal,"* ]]; then
	packages+=('fpc')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",php,"* ]]; then
	packages+=('php-cli')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",php,"* ]]; then
	packages+=('php-pear')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",prolog,"* ]]; then
	packages+=('gprolog')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('python3.8')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('python3.8-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('python3.8-tk')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('python3.8-venv')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('libtk8.6')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('libevent-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('gcc')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	packages+=('tk-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libsdl-ttf2.0-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libportmidi-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libsdl1.2-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libsdl-image1.2-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libsdl-mixer1.2-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('xfonts-base')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('xfonts-100dpi')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('xfonts-75dpi')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('xfonts-cyrillic')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('fontconfig')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('fonts-freefont-ttf')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	packages+=('libfreetype6-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",python,"* ]]; then
	packages+=('python-pip')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",python,"* ]]; then
	packages+=('python-wheel')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",python,"* ]]; then
	packages+=('python-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",python,"* ]]; then
	packages+=('python-tk')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pyxel,"* ]]; then
	packages+=('libglfw3-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pyxel,"* ]]; then
	packages+=('portaudio19-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",pyxel,"* ]]; then
	packages+=('libsdl2-image-2.0-0')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",raku,"* ]]; then
	packages+=('rakudo-pkg')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('r-base')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('r-base-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('r-recommended')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('littler')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('r-cran-littler')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rlang,"* ]]; then
	packages+=('r-cran-stringr')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('rake-compiler')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('ruby-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('ruby')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('rubygems-integration')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('rubygems')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	packages+=('libsqlite3-dev')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",rust,"* ]]; then
	packages+=('rust-gdb')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('libedit2')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('python2.7-minimal')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('libpython2.7')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('libxml2')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	packages+=('clang')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",tcl,"* ]]; then
	packages+=('tcl8.6')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",tcl,"* ]]; then
	packages+=('tklib')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",tcl,"* ]]; then
	packages+=('tcllib')
fi
if [[ -z "${LANGS}" || ",${LANGS}," == *",tcl,"* ]]; then
	packages+=('tcl-dev')
fi

DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${packages[@]}" || exit 1
rm -rf /var/lib/apt/lists/*

rm /phase1.sh
