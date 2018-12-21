ARG LANGS=
FROM node:8.14.0-alpine
ARG LANGS
RUN mkdir -p out
ADD gen gen
RUN cd gen && npm install
ADD languages languages
ADD packages.txt packages.txt
RUN node gen/index.js

FROM ubuntu:18.04

COPY --from=0 /out/phase1.sh /phase1.sh
RUN /bin/bash phase1.sh

COPY --from=0 /out/phase2.sh /phase2.sh
RUN /bin/bash phase2.sh


COPY --from=0 /out/run-project /usr/bin/run-project
COPY --from=0 /out/detect-language /usr/bin/detect-language
COPY --from=0 /out/self-test /usr/bin/polygott-self-test

WORKDIR /home/runner

