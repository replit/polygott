FROM replco/upm:light AS upm

FROM node:8.14.0-alpine AS alpine

ARG PRYBAR_TAG=circleci_pipeline_87_build_94
ADD fetch-prybar.sh fetch-prybar.sh
RUN sh fetch-prybar.sh $PRYBAR_TAG
ADD build-prybar-lang.sh build-prybar-lang.sh

FROM gcc AS websockify
RUN git clone --depth=1 https://github.com/novnc/websockify.git /root/websockify && \
    cd /root/websockify && make

FROM ubuntu:18.04 AS polygott-phase0
ARG LANGS
ENV LANGS=${LANGS}

COPY --from=alpine /gocode /gocode
COPY --from=alpine /build-prybar-lang.sh /usr/bin/build-prybar-lang.sh
COPY --from=alpine /usr/bin/prybar_assets /usr/bin/prybar_assets

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

FROM polygott-phase2 AS polygott-tools

RUN echo '[core]\n    excludesFile = /etc/.gitignore' > /etc/gitconfig
ADD polygott-gitignore /etc/.gitignore

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

ENV \
        APT_OPTIONS="-o debug::nolocking=true -o dir::cache=/tmp/apt/cache -o dir::state=/tmp/apt/state -o dir::etc::sourcelist=/tmp/apt/sources/sources.list" \
        CPATH="${INCLUDE_PATH}" \
        CPPPATH="${INCLUDE_PATH}" \
        DISPLAY=:0 \
        INCLUDE_PATH="/home/runner/.apt/usr/include:$HOME/.apt/usr/include/x86_64-linux-gnu:${INCLUDE_PATH}" \
        LANG=en_US.UTF-8 \
        LC_ALL=en_US.UTF-8 \
        LD_LIBRARY_PATH="/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/home/runner/.apt/usr/lib:${LD_LIBRARY_PATH}" \
        LIBRARY_PATH="/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/home/runner/.apt/usr/lib:${LIBRARY_PATH}" \
        PATH="/usr/local/go/bin:/opt/virtualenvs/python3/bin:/usr/GNUstep/System/Tools:/usr/GNUstep/Local/Tools:/home/runner/.apt/usr/bin:${PATH}" \
        PKG_CONFIG_PATH="${HOME}/.apt/usr/lib/x86_64-linux-gnu/pkgconfig:${HOME}/.apt/usr/lib/i386-linux-gnu/pkgconfig:${HOME}/.apt/usr/lib/pkgconfig:${PKG_CONFIG_PATH}" \
        PYTHONPATH="/opt/virtualenvs/python3/lib/python3.8/site-packages" \
        USER=runner \
        VIRTUAL_ENV="/opt/virtualenvs/python3"

COPY run_dir /run_dir/

COPY fluxbox-init /etc/X11/fluxbox/init
RUN ln -sf /usr/lib/chromium-browser/chromedriver /usr/local/bin

COPY extra/apt-install /usr/bin/install-pkg

COPY extra/_test_runner.py /home/runner/_test_runner.py
COPY extra/cquery11 /opt/homes/cpp11/.cquery
COPY extra/pycodestyle ${XDG_CONFIG_HOME}/pycodestyle
COPY extra/pylintrc /etc/pylintrc
COPY extra/config.toml ${XDG_CONFIG_HOME}/pypoetry/config.toml

COPY extra/replit-v2.py /usr/local/lib/python3.6/dist-packages/replit.py
COPY extra/replit-v2.py /usr/local/lib/python2.7/dist-packages/replit.py
COPY extra/matplotlibrc /config/matplotlib/matplotlibrc

ADD lang-gitignore /etc/.gitignore

WORKDIR /home/runner
