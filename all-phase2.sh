#!/bin/bash
set -ev
shopt -s dotglob

export HOME=/home/runner

ln -s /usr/lib/chromium-browser/chromedriver /usr/local/bin



echo Setup ballerina
wget https://product-dist.ballerina.io/downloads/0.990.3/ballerina-linux-installer-x64-0.990.3.deb
apt-get install ./ballerina-linux-installer-x64-0.990.3.deb
rm -r ballerina-linux-installer-x64-0.990.3.deb

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for ballerina
	mkdir -p /opt/homes/ballerina
	cp -r /opt/homes/default/* /opt/homes/ballerina
	mv -nt /opt/homes/ballerina/ /home/runner/*
	ls -A /opt/homes/ballerina
fi


echo Setup bash
cd /tmp && wget --quiet https://github.com/ewiger/beautify_bash/archive/master.tar.gz && tar xfz master.tar.gz && cp beautify_bash-master/beautify_bash.py /bin/ && chmod +x /bin/beautify_bash.py && rm -rf beautify_bash-master && rm -rf master.tar.gz

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for bash
	mkdir -p /opt/homes/bash
	cp -r /opt/homes/default/* /opt/homes/bash
	mv -nt /opt/homes/bash/ /home/runner/*
	ls -A /opt/homes/bash
fi


echo Setup c
cd /tmp && wget -q https://github.com/cquery-project/cquery/releases/download/v20180302/cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && tar xf cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && cd cquery-v20180302-x86_64-unknown-linux-gnu && cp bin/cquery /bin && cp -r lib/* /lib/ && cd /tmp && rm cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && rm -r cquery-v20180302-x86_64-unknown-linux-gnu
update-alternatives --install /usr/bin/clang-format clang-format `which clang-format-7` 100
mkdir -p /config/cquery && echo -e '%clang\n%c -std=c11\n%cpp -std=c++17\n-pthread' | tee /config/cquery/.cquery

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for c
	mkdir -p /opt/homes/c
	cp -r /opt/homes/default/* /opt/homes/c
	mv -nt /opt/homes/c/ /home/runner/*
	ls -A /opt/homes/c
fi


echo Setup common lisp

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for common lisp
	mkdir -p /opt/homes/common lisp
	cp -r /opt/homes/default/* /opt/homes/common lisp
	mv -nt /opt/homes/common lisp/ /home/runner/*
	ls -A /opt/homes/common lisp
fi


echo Setup clojure
wget https://download.clojure.org/install/linux-install-1.10.1.478.sh
chmod +x linux-install-1.10.1.478.sh
./linux-install-1.10.1.478.sh
rm linux-install-1.10.1.478.sh
clojure -Sverbose -Sdeps '{:mvn/local-repo "/home/runner/.m2/repository"}' --eval ''
mv /root/.m2/repository $XDG_CONFIG_HOME/clojure/repository && rm -rf /root/.m2
/usr/bin/build-prybar-lang.sh clojure

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for clojure
	mkdir -p /opt/homes/clojure
	cp -r /opt/homes/default/* /opt/homes/clojure
	mv -nt /opt/homes/clojure/ /home/runner/*
	ls -A /opt/homes/clojure
fi


echo Setup cpp
#cd /tmp && wget -q https://github.com/cquery-project/cquery/releases/download/v20180302/cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && tar xf cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && cd cquery-v20180302-x86_64-unknown-linux-gnu && cp bin/cquery /bin && cp -r lib/* /lib/ && cd /tmp && rm cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && rm -r cquery-v20180302-x86_64-unknown-linux-gnu
#update-alternatives --install /usr/bin/clang-format clang-format `which clang-format-7` 100

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for cpp
	mkdir -p /opt/homes/cpp
	cp -r /opt/homes/default/* /opt/homes/cpp
	mv -nt /opt/homes/cpp/ /home/runner/*
	ls -A /opt/homes/cpp
fi


echo Setup cpp11
#cd /tmp && wget -q https://github.com/cquery-project/cquery/releases/download/v20180302/cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && tar xf cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && cd cquery-v20180302-x86_64-unknown-linux-gnu && cp bin/cquery /bin && cp -r lib/* /lib/ && cd /tmp && rm cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && rm -r cquery-v20180302-x86_64-unknown-linux-gnu
#update-alternatives --install /usr/bin/clang-format clang-format `which clang-format-7` 100

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for cpp11
	mkdir -p /opt/homes/cpp11
	cp -r /opt/homes/default/* /opt/homes/cpp11
	mv -nt /opt/homes/cpp11/ /home/runner/*
	ls -A /opt/homes/cpp11
fi


echo Setup dart
ln -s /usr/lib/dart/bin/pub /usr/local/bin/pub

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for dart
	mkdir -p /opt/homes/dart
	cp -r /opt/homes/default/* /opt/homes/dart
	mv -nt /opt/homes/dart/ /home/runner/*
	ls -A /opt/homes/dart
fi


echo Setup deno
curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr sh -s v1.1.0
npm i -g typescript-language-server@0.4.0 typescript@3.8.3

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for deno
	mkdir -p /opt/homes/deno
	cp -r /opt/homes/default/* /opt/homes/deno
	mv -nt /opt/homes/deno/ /home/runner/*
	ls -A /opt/homes/deno
fi


echo Setup elisp
git clone https://github.com/cask/cask.git /usr/local/cask
ln -s /usr/local/cask/bin/cask /usr/local/bin/cask
cask upgrade-cask
/usr/bin/build-prybar-lang.sh elisp

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for elisp
	mkdir -p /opt/homes/elisp
	cp -r /opt/homes/default/* /opt/homes/elisp
	mv -nt /opt/homes/elisp/ /home/runner/*
	ls -A /opt/homes/elisp
fi


echo Setup enzyme
yarn add react react-dom react-addons-test-utils jsdom enzyme babel-core babel-preset-latest babel-preset-react babel-polyfill

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for enzyme
	mkdir -p /opt/homes/enzyme
	cp -r /opt/homes/default/* /opt/homes/enzyme
	mv -nt /opt/homes/enzyme/ /home/runner/*
	ls -A /opt/homes/enzyme
fi


echo Setup express
npm install -g jest@23.1.0 prettier@1.13.4 babylon@6.15 babel-traverse@6.21 walker@1.0.7

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for express
	mkdir -p /opt/homes/express
	cp -r /opt/homes/default/* /opt/homes/express
	mv -nt /opt/homes/express/ /home/runner/*
	ls -A /opt/homes/express
fi


echo Setup flow
npm install -g flow-language-server-amasad flow-bin

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for flow
	mkdir -p /opt/homes/flow
	cp -r /opt/homes/default/* /opt/homes/flow
	mv -nt /opt/homes/flow/ /home/runner/*
	ls -A /opt/homes/flow
fi


echo Setup forth

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for forth
	mkdir -p /opt/homes/forth
	cp -r /opt/homes/default/* /opt/homes/forth
	mv -nt /opt/homes/forth/ /home/runner/*
	ls -A /opt/homes/forth
fi


echo Setup gatsbyjs
rm -f /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout
npm install -g prettier@1.13.4 gatsby-cli
gatsby new /home/runner && rm LICENSE && rm README.md && rm .prettierrc && rm .gitignore
yarn

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for gatsbyjs
	mkdir -p /opt/homes/gatsbyjs
	cp -r /opt/homes/default/* /opt/homes/gatsbyjs
	mv -nt /opt/homes/gatsbyjs/ /home/runner/*
	ls -A /opt/homes/gatsbyjs
fi


echo Setup go
go get -u github.com/saibing/bingo

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for go
	mkdir -p /opt/homes/go
	cp -r /opt/homes/default/* /opt/homes/go
	mv -nt /opt/homes/go/ /home/runner/*
	ls -A /opt/homes/go
fi


echo Setup guile

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for guile
	mkdir -p /opt/homes/guile
	cp -r /opt/homes/default/* /opt/homes/guile
	mv -nt /opt/homes/guile/ /home/runner/*
	ls -A /opt/homes/guile
fi


echo Setup java
mkdir -p /config/language-server && cd /config/language-server && wget http://download.eclipse.org/jdtls/milestones/0.21.0/jdt-language-server-0.21.0-201806152234.tar.gz && tar -xzf jdt-language-server-0.21.0-201806152234.tar.gz && rm jdt-language-server-0.21.0-201806152234.tar.gz && chown runner:runner -R /config/language-server
echo '<project> <modelVersion>4.0.0</modelVersion> <groupId>mygroupid</groupId> <artifactId>myartifactid</artifactId> <version>0.0-SNAPSHOT</version> <build><plugins> <plugin> <groupId>de.qaware.maven</groupId> <artifactId>go-offline-maven-plugin</artifactId> <version>1.2.5</version> <configuration> <dynamicDependencies> <DynamicDependency> <groupId>org.apache.maven.surefire</groupId> <artifactId>surefire-junit4</artifactId> <version>2.20.1</version> <repositoryType>PLUGIN</repositoryType> </DynamicDependency> <DynamicDependency> <groupId>com.querydsl</groupId> <artifactId>querydsl-apt</artifactId> <version>4.2.1</version> <classifier>jpa</classifier> <repositoryType>MAIN</repositoryType> </DynamicDependency> </dynamicDependencies> </configuration> </plugin> </plugins></build> </project>' > /tmp/emptypom.xml
mvn -f /tmp/emptypom.xml -Dmaven.repo.local=/home/runner/.m2/repository de.qaware.maven:go-offline-maven-plugin:resolve-dependencies dependency:copy-dependencies
rm /tmp/emptypom.xml

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for java
	mkdir -p /opt/homes/java
	cp -r /opt/homes/default/* /opt/homes/java
	mv -nt /opt/homes/java/ /home/runner/*
	ls -A /opt/homes/java
fi


echo Setup jest
yarn global add jest

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for jest
	mkdir -p /opt/homes/jest
	cp -r /opt/homes/default/* /opt/homes/jest
	mv -nt /opt/homes/jest/ /home/runner/*
	ls -A /opt/homes/jest
fi


echo Setup julia
wget https://julialang-s3.julialang.org/bin/linux/x64/1.3/julia-1.3.1-linux-x86_64.tar.gz
tar xf julia-1.3.1-linux-x86_64.tar.gz
cp julia-1.3.1/bin/julia /usr/bin/
cp -r julia-1.3.1/lib/* /usr/lib/
cp -r julia-1.3.1/include/* /usr/include/
cp -r julia-1.3.1/share/* /usr/share/
rm -rf ./julia-1.3.1 julia-1.3.1-linux-x86_64.tar.gz
/usr/bin/build-prybar-lang.sh julia

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for julia
	mkdir -p /opt/homes/julia
	cp -r /opt/homes/default/* /opt/homes/julia
	mv -nt /opt/homes/julia/ /home/runner/*
	ls -A /opt/homes/julia
fi


echo Setup kotlin
wget https://github.com/JetBrains/kotlin/releases/download/v1.0.3/kotlin-compiler-1.0.3.zip -O /tmp/a.zip
unzip /tmp/a.zip -d /opt
rm /tmp/a.zip
ln -s /opt/kotlinc/bin/kotlin{,c,c-js,c-jvm} /usr/local/bin/

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for kotlin
	mkdir -p /opt/homes/kotlin
	cp -r /opt/homes/default/* /opt/homes/kotlin
	mv -nt /opt/homes/kotlin/ /home/runner/*
	ls -A /opt/homes/kotlin
fi


echo Setup love2d

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for love2d
	mkdir -p /opt/homes/love2d
	cp -r /opt/homes/default/* /opt/homes/love2d
	mv -nt /opt/homes/love2d/ /home/runner/*
	ls -A /opt/homes/love2d
fi


echo Setup lua
luarocks install formatter && luarocks install metalua && luarocks install penlight
/usr/bin/build-prybar-lang.sh lua

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for lua
	mkdir -p /opt/homes/lua
	cp -r /opt/homes/default/* /opt/homes/lua
	mv -nt /opt/homes/lua/ /home/runner/*
	ls -A /opt/homes/lua
fi


echo Setup nextjs
npm install -g prettier@1.13.4
mkdir -p /home/runner/pages
yarn install

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for nextjs
	mkdir -p /opt/homes/nextjs
	cp -r /opt/homes/default/* /opt/homes/nextjs
	mv -nt /opt/homes/nextjs/ /home/runner/*
	ls -A /opt/homes/nextjs
fi


echo Setup nim
NIM_VER="1.2.0"
wget https://nim-lang.org/download/nim-$NIM_VER.tar.xz
tar xf nim-$NIM_VER.tar.xz
rm -rf nim-$NIM_VER.tar.xz
chown -R root: nim-$NIM_VER/
cd nim-$NIM_VER
sh build.sh
./bin/nim c koch.nim
./koch tools
sh install.sh /usr/local/bin
cp ./bin/* /usr/local/bin
cd ..
rm -rf nim-$NIM_VER
unset NIM_VER

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for nim
	mkdir -p /opt/homes/nim
	cp -r /opt/homes/default/* /opt/homes/nim
	mv -nt /opt/homes/nim/ /home/runner/*
	ls -A /opt/homes/nim
fi


echo Setup nodejs
#npm install -g jest@23.1.0 prettier@1.13.4 babylon@6.15 babel-traverse@6.21 walker@1.0.7
/usr/bin/build-prybar-lang.sh nodejs

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for nodejs
	mkdir -p /opt/homes/nodejs
	cp -r /opt/homes/default/* /opt/homes/nodejs
	mv -nt /opt/homes/nodejs/ /home/runner/*
	ls -A /opt/homes/nodejs
fi


echo Setup ocaml
opam init -c ocaml-system -n --disable-sandboxing
/usr/bin/build-prybar-lang.sh ocaml

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for ocaml
	mkdir -p /opt/homes/ocaml
	cp -r /opt/homes/default/* /opt/homes/ocaml
	mv -nt /opt/homes/ocaml/ /home/runner/*
	ls -A /opt/homes/ocaml
fi


echo Setup pascal

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for pascal
	mkdir -p /opt/homes/pascal
	cp -r /opt/homes/default/* /opt/homes/pascal
	mv -nt /opt/homes/pascal/ /home/runner/*
	ls -A /opt/homes/pascal
fi


echo Setup powershell
curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.0.2/powershell-7.0.2-linux-x64.tar.gz
mkdir /usr/local/pwsh
tar zxf /tmp/powershell.tar.gz -C /usr/local/pwsh
ln -s -f /usr/local/pwsh/pwsh /usr/bin/pwsh
rm -f /tmp/powershell.tar.gz

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for powershell
	mkdir -p /opt/homes/powershell
	cp -r /opt/homes/default/* /opt/homes/powershell
	mv -nt /opt/homes/powershell/ /home/runner/*
	ls -A /opt/homes/powershell
fi


echo Setup python3
ln -s /usr/bin/python3.8 /usr/local/bin/python3
curl https://bootstrap.pypa.io/get-pip.py | python3
python3 -m venv /opt/virtualenvs/python3
/opt/virtualenvs/python3/bin/pip3 install --disable-pip-version-check pipreqs-amasad==0.4.10 pylint==1.6.4 jedi==0.13.2 mccabe==0.6.1 pycodestyle==2.4.0 pyflakes==2.1.1 python-language-server==0.21.5 rope==0.11.0 yapf==0.25.0 dephell==0.7.7 poetry==0.12.16
/opt/virtualenvs/python3/bin/pip3 install poetry==1.0.5 bpython matplotlib nltk numpy ptpython requests scipy replit==1.2.3
/opt/virtualenvs/python3/bin/pip3 install cs50
/opt/virtualenvs/python3/bin/pip3 install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-2.2.0-cp38-cp38-manylinux2010_x86_64.whl
/usr/bin/build-prybar-lang.sh python3

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for python3
	mkdir -p /opt/homes/python3
	cp -r /opt/homes/default/* /opt/homes/python3
	mv -nt /opt/homes/python3/ /home/runner/*
	ls -A /opt/homes/python3
fi


echo Setup pygame
/opt/virtualenvs/python3/bin/python3 -m pip install pygame

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for pygame
	mkdir -p /opt/homes/pygame
	cp -r /opt/homes/default/* /opt/homes/pygame
	mv -nt /opt/homes/pygame/ /home/runner/*
	ls -A /opt/homes/pygame
fi


echo Setup python
wget https://storage.googleapis.com/container-bins/stderred_1.0_amd64.deb && dpkg -i stderred_1.0_amd64.deb && rm stderred_1.0_amd64.deb
pip2 install -U setuptools
pip2 install -U configparser
pip2 install --no-cache-dir pipreqs-amasad==0.4.10 jedi==0.12.1 pyflakes==2.0.0 rope==0.11.0 yapf==0.25.0 mccabe==0.6.1 nltk numpy scipy requests matplotlib bpython ptpython

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for python
	mkdir -p /opt/homes/python
	cp -r /opt/homes/default/* /opt/homes/python
	mv -nt /opt/homes/python/ /home/runner/*
	ls -A /opt/homes/python
fi


echo Setup pyxel
/opt/virtualenvs/python3/bin/python3 -m pip install glfw
/opt/virtualenvs/python3/bin/python3 -m pip install git+https://github.com/amasad/pyxel

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for pyxel
	mkdir -p /opt/homes/pyxel
	cp -r /opt/homes/default/* /opt/homes/pyxel
	mv -nt /opt/homes/pyxel/ /home/runner/*
	ls -A /opt/homes/pyxel
fi


echo Setup quil
pip3 install referenceqvm==0.3 pyquil==1.9.0

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for quil
	mkdir -p /opt/homes/quil
	cp -r /opt/homes/default/* /opt/homes/quil
	mv -nt /opt/homes/quil/ /home/runner/*
	ls -A /opt/homes/quil
fi


echo Setup raku
ln -s /opt/rakudo-pkg/bin/perl6 /usr/local/bin/perl6
ln -s /opt/rakudo-pkg/bin/raku /usr/local/bin/raku
ln -s /opt/rakudo-pkg/bin/nqp /usr/local/bin/nqp
ln -s /opt/rakudo-pkg/bin/moar /usr/local/bin/moar
ln -s /opt/rakudo-pkg/bin/zef /usr/local/bin/zef
zef install Linenoise

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for raku
	mkdir -p /opt/homes/raku
	cp -r /opt/homes/default/* /opt/homes/raku
	mv -nt /opt/homes/raku/ /home/runner/*
	ls -A /opt/homes/raku
fi


echo Setup react_native
#yarn global add jest
#yarn

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for react_native
	mkdir -p /opt/homes/react_native
	cp -r /opt/homes/default/* /opt/homes/react_native
	mv -nt /opt/homes/react_native/ /home/runner/*
	ls -A /opt/homes/react_native
fi


echo Setup reactjs
rm -f /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout && npx create-react-app /home/runner && yarn && rm README.md && chown runner:runner -R /home/runner && yarn global add prettier@1.13.4

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for reactjs
	mkdir -p /opt/homes/reactjs
	cp -r /opt/homes/default/* /opt/homes/reactjs
	mv -nt /opt/homes/reactjs/ /home/runner/*
	ls -A /opt/homes/reactjs
fi


echo Setup reactts
rm -f /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout && npx create-react-app --scripts-version=react-scripts-ts /home/runner && yarn && rm README.md && chown runner:runner -R /home/runner && yarn global add prettier@1.13.4

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for reactts
	mkdir -p /opt/homes/reactts
	cp -r /opt/homes/default/* /opt/homes/reactts
	mv -nt /opt/homes/reactts/ /home/runner/*
	ls -A /opt/homes/reactts
fi


echo Setup ruby
gem install --source http://rubygems.org rspec:3.5 stripe rufo sinatra
gem install solargraph -v 0.38.1
/usr/bin/build-prybar-lang.sh ruby

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for ruby
	mkdir -p /opt/homes/ruby
	cp -r /opt/homes/default/* /opt/homes/ruby
	mv -nt /opt/homes/ruby/ /home/runner/*
	ls -A /opt/homes/ruby
fi


echo Setup rust
curl --proto '=https' --tlsv1.2 -Sf https://static.rust-lang.org/dist/rust-1.44.0-x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
/tmp/rust-1.44.0-x86_64-unknown-linux-gnu/install.sh
rm -rf /tmp/rust-1.44.0-x86_64-unknown-linux-gnu

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for rust
	mkdir -p /opt/homes/rust
	cp -r /opt/homes/default/* /opt/homes/rust
	mv -nt /opt/homes/rust/ /home/runner/*
	ls -A /opt/homes/rust
fi


echo Setup scala
wget -nv https://downloads.lightbend.com/scala/2.13.1/scala-2.13.1.tgz
tar -xf scala-2.13.1.tgz
cp -R   scala-2.13.1/bin/*     /usr/local/bin/
cp -R   scala-2.13.1/lib/*     /usr/local/lib/
rm -rf  scala-2.13.1/
/usr/bin/build-prybar-lang.sh scala

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for scala
	mkdir -p /opt/homes/scala
	cp -r /opt/homes/default/* /opt/homes/scala
	mv -nt /opt/homes/scala/ /home/runner/*
	ls -A /opt/homes/scala
fi


echo Setup sqlite
/usr/bin/build-prybar-lang.sh sqlite

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for sqlite
	mkdir -p /opt/homes/sqlite
	cp -r /opt/homes/default/* /opt/homes/sqlite
	mv -nt /opt/homes/sqlite/ /home/runner/*
	ls -A /opt/homes/sqlite
fi


echo Setup swift
wget https://swift.org/builds/swift-5.0.1-release/ubuntu1804/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
wget https://swift.org/builds/swift-5.0.1-release/ubuntu1804/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig
gpg --keyserver hkp://ipv4.pool.sks-keyservers.net         --recv-keys          '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD'          '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F'          'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6'          '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235'          '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4' 'A62A E125 BBBF BB96 A6E0 42EC 925C C1CC ED3D 1561'
gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --refresh-keys
gpg --verify swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig || exit 1
tar xzvf swift-5.0.1-RELEASE-ubuntu18.04.tar.gz --strip-components=1 -C /
rm swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
rm swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig
chmod -R go+r /usr/lib/swift
swift --version

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for swift
	mkdir -p /opt/homes/swift
	cp -r /opt/homes/default/* /opt/homes/swift
	mv -nt /opt/homes/swift/ /home/runner/*
	ls -A /opt/homes/swift
fi


echo Setup tcl
cp /gocode/src/github.com/replit/prybar/languages/tcl/tcl.pc /usr/lib/pkgconfig/tcl.pc
/usr/bin/build-prybar-lang.sh tcl

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for tcl
	mkdir -p /opt/homes/tcl
	cp -r /opt/homes/default/* /opt/homes/tcl
	mv -nt /opt/homes/tcl/ /home/runner/*
	ls -A /opt/homes/tcl
fi


echo Setup WebAssembly
wget https://github.com/wasmerio/wasmer/releases/download/0.14.0/wasmer-linux-amd64.tar.gz -O /tmp/wasmer.tar.gz
mkdir /usr/local/wasmer
tar -xvf /tmp/wasmer.tar.gz -C /usr/local/wasmer --strip-components=1
ln -s /usr/local/wasmer/wasmer /usr/local/bin/wasmer
rm /tmp/wasmer.tar.gz

if [ -n "$(ls -A /home/runner)" ]; then
	echo Storing home for WebAssembly
	mkdir -p /opt/homes/WebAssembly
	cp -r /opt/homes/default/* /opt/homes/WebAssembly
	mv -nt /opt/homes/WebAssembly/ /home/runner/*
	ls -A /opt/homes/WebAssembly
fi

chown runner:runner -R /opt/homes
cp -r /opt/homes/default/* /home/runner
chown runner:runner -R /home/runner
chown runner:runner -R /config
chown runner:runner -R /opt/virtualenvs

rm -rf /var/lib/apt/lists/*
rm /phase2.sh
