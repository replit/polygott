# syntax = docker/dockerfile:1.2@sha256:e2a8561e419ab1ba6b2fe6cbdf49fd92b95912df1cf7d313c3e2230a333fdbcc


## The base image from which all others will extend.
## Installs the base packages, certificates, and a few choice .deb files.
FROM ubuntu:18.04@sha256:ea188fdc5be9b25ca048f1e882b33f1bc763fb976a8a4fea446b38ed0efcbeba AS polygott-phase0
COPY ./out/phase0.sh /phase0.sh
RUN --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase0.sh

# Environment variables that are depended on by phase1 files.
# TODO: Remove XDG_CONFIG_HOME, since that will be used for user overrides.
ENV XDG_CONFIG_HOME=/config
ENV XDG_CONFIG_DIRS=/config


## Runs apt-get update.
FROM polygott-phase0 AS polygott-phase1.0
RUN --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    mkdir -p /var/lib/apt/lists/auxfiles


## Image for prybar resources
FROM polygott-phase0 AS prybar

ARG PRYBAR_TAG=circleci_pipeline_87_build_94
ARG PRYBAR_TAG=circleci_pipeline_87_build_94
RUN mkdir -p /gocode/src/github.com/replit/ && \
    wget "https://github.com/replit/prybar/archive/${PRYBAR_TAG}.zip" && \
    unzip "${PRYBAR_TAG}.zip" && \
    mv "prybar-${PRYBAR_TAG}" /gocode/src/github.com/replit/prybar/ && \
    cp -r /gocode/src/github.com/replit/prybar/prybar_assets /usr/bin/prybar_assets/


## Installs the per-language packages.
FROM polygott-phase0 AS polygott-phase1.5
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      autoconf \
      automake \
      clang \
      clang-7 \
      clang-8 \
      clang-format-7 \
      crystal \
      dart=2.6.0-1 \
      elixir \
      emacs26 \
      esl-erlang \
      fontconfig \
      fonts-freefont-ttf \
      fpc \
      fsharp \
      gcc \
      gdb \
      gdc \
      gforth \
      gforth-common \
      gforth-lib \
      gfortran \
      ghc \
      gprolog \
      guile-2.2 \
      haxe \
      libblocksruntime-dev \
      libcairo-dev \
      libcs50 \
      libedit2 \
      libevent-dev \
      libffi-dev \
      libfreetype6-dev \
      libglfw3-dev \
      libgnutls28-dev \
      libicu-dev \
      libjpeg-dev \
      libkqueue-dev \
      liblua5.1-0 \
      liblua5.1-bitop0 \
      libmbedtls-dev \
      libopenal-dev \
      libpng-dev \
      libportmidi-dev \
      libpthread-workqueue-dev \
      libpython2.7 \
      libsdl-image1.2-dev \
      libsdl-mixer1.2-dev \
      libsdl-ttf2.0-dev \
      libsdl1.2-dev \
      libsdl2-image-2.0-0 \
      libsqlite3-dev \
      libssl-dev \
      libtiff-dev \
      libtk8.6 \
      libtool \
      libtool-bin \
      libturbojpeg-dev \
      libuv1-dev \
      libvorbis-dev \
      libx11-dev \
      libxft-dev \
      libxml2 \
      libxml2-dev \
      libxrandr-dev \
      libxt-dev \
      libz-dev \
      littler \
      love \
      lua-socket \
      lua5.1 \
      luarocks \
      m4 \
      maven \
      mercury-examples \
      mercury-recommended \
      mono-complete \
      nasm \
      nodejs \
      ocaml \
      opam \
      openjdk-11-jdk \
      openjdk-11-jre-headless \
      php-cli \
      php-pear \
      pkg-config \
      portaudio19-dev \
      python-dev \
      python-pip \
      python-tk \
      python-wheel \
      python2.7-minimal \
      python3.8 \
      python3.8-dev \
      python3.8-tk \
      python3.8-venv \
      r-base \
      r-base-dev \
      r-cran-littler \
      r-cran-stringr \
      r-recommended \
      rake-compiler \
      rakudo-pkg=2021.3.0-01 \
      ruby \
      ruby-dev \
      rubygems \
      rubygems-integration \
      rust-gdb \
      sbcl \
      sqlite3 \
      tcl-dev \
      tcl8.6 \
      tcllib \
      tk-dev \
      tklib \
      xfonts-100dpi \
      xfonts-75dpi \
      xfonts-base \
      xfonts-cyrillic

COPY ./extra/build-prybar-lang.sh /usr/bin/build-prybar-lang.sh
COPY --from=prybar /gocode /gocode
COPY --from=prybar /usr/bin/prybar_assets /usr/bin/prybar_assets


## The individual language layer for assembly.
FROM polygott-phase1.5 AS polygott-phase2-assembly
COPY ./out/share/polygott/phase2.d/assembly /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for java.
FROM polygott-phase1.5 AS polygott-phase2-java
COPY ./out/share/polygott/phase2.d/java /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for ballerina.
FROM polygott-phase2-java AS polygott-phase2-ballerina
COPY ./out/share/polygott/phase2.d/ballerina /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for bash.
FROM polygott-phase1.5 AS polygott-phase2-bash
COPY ./out/share/polygott/phase2.d/bash /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for c.
FROM polygott-phase1.5 AS polygott-phase2-c
COPY ./out/share/polygott/phase2.d/c /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for clisp.
FROM polygott-phase1.5 AS polygott-phase2-clisp
COPY ./out/share/polygott/phase2.d/clisp /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for clojure.
FROM polygott-phase1.5 AS polygott-phase2-clojure
COPY ./out/share/polygott/phase2.d/clojure /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for cpp.
FROM polygott-phase2-c AS polygott-phase2-cpp
COPY ./out/share/polygott/phase2.d/cpp /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for cpp11.
FROM polygott-phase2-c AS polygott-phase2-cpp11
COPY ./out/share/polygott/phase2.d/cpp11 /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for crystal.
FROM polygott-phase1.5 AS polygott-phase2-crystal
COPY ./out/share/polygott/phase2.d/crystal /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for csharp.
FROM polygott-phase1.5 AS polygott-phase2-csharp
COPY ./out/share/polygott/phase2.d/csharp /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for d.
FROM polygott-phase1.5 AS polygott-phase2-d
COPY ./out/share/polygott/phase2.d/d /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for dart.
FROM polygott-phase1.5 AS polygott-phase2-dart
COPY ./out/share/polygott/phase2.d/dart /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for deno.
FROM polygott-phase1.5 AS polygott-phase2-deno
COPY ./out/share/polygott/phase2.d/deno /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for elisp.
FROM polygott-phase1.5 AS polygott-phase2-elisp
COPY ./out/share/polygott/phase2.d/elisp /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for erlang.
FROM polygott-phase1.5 AS polygott-phase2-erlang
COPY ./out/share/polygott/phase2.d/erlang /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for elixir.
FROM polygott-phase2-erlang AS polygott-phase2-elixir
COPY ./out/share/polygott/phase2.d/elixir /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for nodejs.
FROM polygott-phase1.5 AS polygott-phase2-nodejs
COPY ./out/share/polygott/phase2.d/nodejs /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for enzyme.
FROM polygott-phase2-nodejs AS polygott-phase2-enzyme
COPY ./out/share/polygott/phase2.d/enzyme /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for express.
FROM polygott-phase1.5 AS polygott-phase2-express
COPY ./out/share/polygott/phase2.d/express /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for flow.
FROM polygott-phase2-nodejs AS polygott-phase2-flow
COPY ./out/share/polygott/phase2.d/flow /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for forth.
FROM polygott-phase1.5 AS polygott-phase2-forth
COPY ./out/share/polygott/phase2.d/forth /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for fortran.
FROM polygott-phase1.5 AS polygott-phase2-fortran
COPY ./out/share/polygott/phase2.d/fortran /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for fsharp.
FROM polygott-phase2-csharp AS polygott-phase2-fsharp
COPY ./out/share/polygott/phase2.d/fsharp /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for gatsbyjs.
FROM polygott-phase2-nodejs AS polygott-phase2-gatsbyjs
COPY ./out/share/polygott/phase2.d/gatsbyjs /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for go.
FROM polygott-phase1.5 AS polygott-phase2-go
COPY ./out/share/polygott/phase2.d/go /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for guile.
FROM polygott-phase1.5 AS polygott-phase2-guile
COPY ./out/share/polygott/phase2.d/guile /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for haskell.
FROM polygott-phase1.5 AS polygott-phase2-haskell
COPY ./out/share/polygott/phase2.d/haskell /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for haxe.
FROM polygott-phase1.5 AS polygott-phase2-haxe
COPY ./out/share/polygott/phase2.d/haxe /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for jest.
FROM polygott-phase2-nodejs AS polygott-phase2-jest
COPY ./out/share/polygott/phase2.d/jest /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for julia.
FROM polygott-phase1.5 AS polygott-phase2-julia
COPY ./out/share/polygott/phase2.d/julia /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for kotlin.
FROM polygott-phase1.5 AS polygott-phase2-kotlin
COPY ./out/share/polygott/phase2.d/kotlin /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for love2d.
FROM polygott-phase1.5 AS polygott-phase2-love2d
COPY ./out/share/polygott/phase2.d/love2d /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for lua.
FROM polygott-phase1.5 AS polygott-phase2-lua
COPY ./out/share/polygott/phase2.d/lua /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for mercury.
FROM polygott-phase1.5 AS polygott-phase2-mercury
COPY ./out/share/polygott/phase2.d/mercury /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for nextjs.
FROM polygott-phase2-nodejs AS polygott-phase2-nextjs
COPY ./out/share/polygott/phase2.d/nextjs /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for nim.
FROM polygott-phase1.5 AS polygott-phase2-nim
COPY ./out/share/polygott/phase2.d/nim /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for nix.
FROM polygott-phase1.5 AS polygott-phase2-nix
COPY ./out/share/polygott/phase2.d/nix /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for objective-c.
FROM polygott-phase1.5 AS polygott-phase2-objective-c
COPY ./out/share/polygott/phase2.d/objective-c /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for ocaml.
FROM polygott-phase1.5 AS polygott-phase2-ocaml
COPY ./out/share/polygott/phase2.d/ocaml /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for pascal.
FROM polygott-phase1.5 AS polygott-phase2-pascal
COPY ./out/share/polygott/phase2.d/pascal /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for php.
FROM polygott-phase1.5 AS polygott-phase2-php
COPY ./out/share/polygott/phase2.d/php /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for powershell.
FROM polygott-phase1.5 AS polygott-phase2-powershell
COPY ./out/share/polygott/phase2.d/powershell /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for prolog.
FROM polygott-phase1.5 AS polygott-phase2-prolog
COPY ./out/share/polygott/phase2.d/prolog /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for python3.
FROM polygott-phase1.5 AS polygott-phase2-python3
COPY ./out/share/polygott/phase2.d/python3 /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for pygame.
FROM polygott-phase2-python3 AS polygott-phase2-pygame
COPY ./out/share/polygott/phase2.d/pygame /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for python.
FROM polygott-phase1.5 AS polygott-phase2-python
COPY ./out/share/polygott/phase2.d/python /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for pyxel.
FROM polygott-phase2-python3 AS polygott-phase2-pyxel
COPY ./out/share/polygott/phase2.d/pyxel /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for quil.
FROM polygott-phase2-python3 AS polygott-phase2-quil
COPY ./out/share/polygott/phase2.d/quil /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for raku.
FROM polygott-phase1.5 AS polygott-phase2-raku
COPY ./out/share/polygott/phase2.d/raku /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for react_native.
FROM polygott-phase2-jest AS polygott-phase2-react_native
COPY ./out/share/polygott/phase2.d/react_native /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for reactjs.
FROM polygott-phase2-nodejs AS polygott-phase2-reactjs
COPY ./out/share/polygott/phase2.d/reactjs /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for reactts.
FROM polygott-phase2-nodejs AS polygott-phase2-reactts
COPY ./out/share/polygott/phase2.d/reactts /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for rlang.
FROM polygott-phase1.5 AS polygott-phase2-rlang
COPY ./out/share/polygott/phase2.d/rlang /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for ruby.
FROM polygott-phase1.5 AS polygott-phase2-ruby
COPY ./out/share/polygott/phase2.d/ruby /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for rust.
FROM polygott-phase1.5 AS polygott-phase2-rust
COPY ./out/share/polygott/phase2.d/rust /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for scala.
FROM polygott-phase2-java AS polygott-phase2-scala
COPY ./out/share/polygott/phase2.d/scala /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for sqlite.
FROM polygott-phase1.5 AS polygott-phase2-sqlite
COPY ./out/share/polygott/phase2.d/sqlite /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for swift.
FROM polygott-phase1.5 AS polygott-phase2-swift
COPY ./out/share/polygott/phase2.d/swift /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for tcl.
FROM polygott-phase1.5 AS polygott-phase2-tcl
COPY ./out/share/polygott/phase2.d/tcl /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for webassembly.
FROM polygott-phase1.5 AS polygott-phase2-webassembly
COPY ./out/share/polygott/phase2.d/webassembly /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## The individual language layer for wren.
FROM polygott-phase1.5 AS polygott-phase2-wren
COPY ./out/share/polygott/phase2.d/wren /phase2.sh
RUN --mount=type=bind,from=polygott-phase1.0,source=/var/lib/apt/lists,target=/var/lib/apt/lists,ro \
    --mount=type=tmpfs,target=/var/lib/apt/lists/auxfiles \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/log \
    /bin/bash phase2.sh


## Image to build websockify
FROM polygott-phase1.5 AS websockify
RUN git clone --depth=1 https://github.com/novnc/websockify.git /root/websockify && \
    cd /root/websockify && make


## Import UPM.
FROM replco/upm:light@sha256:fc729728ec975f918953ad6a12497de712ca0858344ddbbeb638f692c60c6167 AS upm


## The polygott-specific tools.
FROM polygott-phase1.5 AS polygott-phase2-tools
RUN curl -sSL https://github.com/replit/rfbproxy/releases/download/v0.1.1-c888349/rfbproxy.tar.xz | tar xJ -C /
RUN echo '[core]\n    excludesFile = /etc/.gitignore' > /etc/gitconfig
COPY ./extra/polygott-gitignore /etc/.gitignore

COPY ./out/run-project /usr/bin/run-project
COPY ./out/run-language-server /usr/bin/run-language-server
COPY ./out/detect-language /usr/bin/detect-language
COPY ./out/self-test /usr/bin/polygott-self-test
COPY ./out/polygott-survey /usr/bin/polygott-survey
COPY ./out/polygott-lang-setup /usr/bin/polygott-lang-setup
COPY ./out/polygott-x11-vnc /usr/bin/polygott-x11-vnc
COPY ./out/share/polygott/self-test.d/ /usr/share/polygott/self-test.d/
COPY --from=upm /usr/local/bin/upm /usr/local/bin/upm
COPY --from=websockify /root/websockify /usr/local/websockify

COPY ./run_dir /run_dir/

RUN ln -sf /usr/lib/chromium-browser/chromedriver /usr/local/bin

COPY ./extra/apt-install /usr/bin/install-pkg
RUN mkdir -p /opt/dap/java/ /opt/dap/python/
COPY ./extra/java-dap /opt/dap/java/run
COPY ./extra/py-dap /opt/dap/python/run
RUN chmod +x /opt/dap/java/run /opt/dap/python/run

COPY ./extra/_test_runner.py /home/runner/_test_runner.py
COPY ./extra/cquery11 /opt/homes/cpp11/.cquery
COPY ./extra/pycodestyle ${XDG_CONFIG_HOME}/pycodestyle
COPY ./extra/pylintrc /etc/pylintrc
COPY ./extra/config.toml ${XDG_CONFIG_HOME}/pypoetry/config.toml

COPY ./extra/replit-v2.py /usr/local/lib/python3.6/dist-packages/replit.py
COPY ./extra/replit-v2.py /usr/local/lib/python2.7/dist-packages/replit.py
COPY ./extra/matplotlibrc /config/matplotlib/matplotlibrc

COPY ./extra/fluxbox/init /etc/X11/fluxbox/init
COPY ./extra/fluxbox/apps /etc/X11/fluxbox/apps
COPY ./extra/pulse/client.conf ./extra/pulse/default.pa /etc/pulse/
COPY ./extra/nixproxy.nix /opt/nixproxy.nix

COPY ./extra/lang-gitignore /etc/.gitignore
