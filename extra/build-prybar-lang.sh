#!/bin/bash -e
LANG="$1"

export GOPATH=/gocode
export LC_ALL=C.UTF-8
export PATH="/gocode/src/github.com/replit/prybar:$PATH"
cd /gocode/src/github.com/replit/prybar
make "prybar-${LANG}"
cp "prybar-${LANG}" /usr/bin/
cp -r prybar_assets/ /usr/bin/