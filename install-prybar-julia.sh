mkdir -p /gocode/src/github.com/replit/
wget https://github.com/replit/prybar/archive/ds-fix-julia.zip
unzip ds-fix-julia.zip
mv prybar-ds-fix-julia /gocode/src/github.com/replit/prybar/
export GOPATH=/gocode
export LC_ALL=C.UTF-8
export PATH="/gocode/src/github.com/replit/prybar:$PATH"
cd /gocode/src/github.com/replit/prybar
cp languages/tcl/tcl.pc /usr/lib/pkgconfig/
make prybar-julia
cp prybar-julia /usr/local/bin/