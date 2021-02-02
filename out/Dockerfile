## Import UPM.
FROM replco/upm:light@sha256:7969cc1285d7900023d68cd3c5fd5155bc9506ac1b0bae56dc49dc690de2c383 AS upm


## Image for prybar resources
FROM node:8.14.0-alpine@sha256:fa979a27cee3c8664a689e27e778b766af72da52920454160421854027374f09 AS prybar

ARG PRYBAR_TAG=circleci_pipeline_87_build_94
COPY ./extra/fetch-prybar.sh fetch-prybar.sh
RUN sh fetch-prybar.sh $PRYBAR_TAG
COPY ./extra/build-prybar-lang.sh build-prybar-lang.sh


## The base image from which all others will extend.
## Installs the base packages, certificats, and a few choice .deb files.
FROM ubuntu:18.04@sha256:ea188fdc5be9b25ca048f1e882b33f1bc763fb976a8a4fea446b38ed0efcbeba AS polygott-phase0
ARG LANGS
ENV LANGS=${LANGS}

COPY --from=prybar /gocode /gocode
COPY --from=prybar /build-prybar-lang.sh /usr/bin/build-prybar-lang.sh
COPY --from=prybar /usr/bin/prybar_assets /usr/bin/prybar_assets

COPY ./out/phase0.sh /phase0.sh
RUN /bin/bash phase0.sh

# Environment variables that are depended on by phase1 files.
ENV XDG_CONFIG_HOME=/config

FROM polygott-phase0 AS polygott-phase1
ARG LANGS
ENV LANGS=${LANGS}

COPY ./out/phase1.sh /phase1.sh
RUN /bin/bash phase1.sh

FROM polygott-phase1 AS polygott-phase2
ARG LANGS
ENV LANGS=${LANGS}

COPY ./out/phase2.sh /phase2.sh
RUN /bin/bash phase2.sh


## Image to build websockify
FROM polygott-phase2 AS websockify
RUN git clone --depth=1 https://github.com/novnc/websockify.git /root/websockify && \
    cd /root/websockify && make


## The polygott-specific tools.
FROM polygott-phase2 AS polygott

RUN echo '[core]\n    excludesFile = /etc/.gitignore' > /etc/gitconfig
COPY ./extra/polygott-gitignore /etc/.gitignore

COPY ./out/run-project /usr/bin/run-project
COPY ./out/run-language-server /usr/bin/run-language-server
COPY ./out/detect-language /usr/bin/detect-language
COPY ./out/self-test /usr/bin/polygott-self-test
COPY ./out/polygott-survey /usr/bin/polygott-survey
COPY ./out/polygott-lang-setup /usr/bin/polygott-lang-setup
COPY ./out/polygott-x11-vnc /usr/bin/polygott-x11-vnc
COPY ./out/share/ /usr/share/
COPY --from=upm /usr/local/bin/upm /usr/local/bin/upm
COPY --from=websockify /root/websockify /usr/local/websockify

COPY ./run_dir /run_dir/

RUN ln -sf /usr/lib/chromium-browser/chromedriver /usr/local/bin

COPY ./extra/apt-install /usr/bin/install-pkg

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

COPY ./extra/lang-gitignore /etc/.gitignore

ENV \
        APT_OPTIONS="-o debug::nolocking=true -o dir::cache=/tmp/apt/cache -o dir::state=/tmp/apt/state -o dir::etc::sourcelist=/tmp/apt/sources/sources.list" \
        CPATH="/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu" \
        CPPPATH="/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu" \
        DISPLAY=":0" \
        HOME="/home/runner" \
        INCLUDE_PATH="/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu" \
        LANG="en_US.UTF-8" \
        LC_ALL="en_US.UTF-8" \
        LD_LIBRARY_PATH="/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/usr/local/lib:/home/runner/.apt/usr/lib" \
        LIBRARY_PATH="/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/usr/local/lib:/home/runner/.apt/usr/lib" \
        PATH="/usr/local/go/bin:/opt/virtualenvs/python3/bin:/usr/GNUstep/System/Tools:/usr/GNUstep/Local/Tools:/home/runner/.apt/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
        PKG_CONFIG_PATH="/home/runner/.apt/usr/lib/x86_64-linux-gnu/pkgconfig:/home/runner/.apt/usr/lib/i386-linux-gnu/pkgconfig:/home/runner/.apt/usr/lib/pkgconfig" \
        PYTHONPATH="/opt/virtualenvs/python3/lib/python3.8/site-packages" \
        USER="runner" \
        VIRTUAL_ENV="/opt/virtualenvs/python3"
WORKDIR /home/runner