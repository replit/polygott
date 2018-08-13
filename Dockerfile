FROM ubuntu:18.04

ADD out/setup.sh /setup.sh
ADD out/run-project /usr/bin/run-project
RUN /bin/bash setup.sh

WORKDIR /home/runner

