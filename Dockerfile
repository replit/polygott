FROM ubuntu:16.04

ADD out/setup.sh /setup.sh
ADD out/run-project /usr/bin/run-project
ADD out/detect-language /usr/bin/detect-language
RUN /bin/bash setup.sh

WORKDIR /home/runner

