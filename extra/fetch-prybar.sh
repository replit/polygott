TAG="$1"

mkdir -p /gocode/src/github.com/replit/

wget "https://github.com/replit/prybar/archive/${TAG}.zip"
unzip "${TAG}.zip"
mv "prybar-${TAG}" /gocode/src/github.com/replit/prybar/
cp -r /gocode/src/github.com/replit/prybar/prybar_assets /usr/bin/prybar_assets/