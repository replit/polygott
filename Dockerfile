FROM ubuntu:18.04
RUN apt-get update && apt-get install -y python3 python3-pip python3-dev build-essential  && pip3 install pytoml
RUN mkdir -p /home/ubuntu/out
ADD setup.py /home/ubuntu/setup.py
ADD languages /home/ubuntu/languages
ADD packages.txt /home/ubuntu/packages.txt
RUN cd /home/ubuntu && /usr/bin/env LANG=en_US.UTF-8 python3 /home/ubuntu/setup.py

FROM ubuntu:16.04

COPY --from=0 /home/ubuntu/out/setup.sh /setup.sh
COPY --from=0 /home/ubuntu/out/run-project /usr/bin/run-project
COPY --from=0 /home/ubuntu/out/detect-language /usr/bin/detect-language
RUN /bin/bash setup.sh

WORKDIR /home/runner

