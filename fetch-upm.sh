TAG="$1"

mkdir -p /gocode/src/github.com/replit/

wget "https://github.com/replit/upm/archive/${TAG}.zip"
unzip "${TAG}.zip"
mv "upm-${TAG}" /gocode/src/github.com/replit/upm/