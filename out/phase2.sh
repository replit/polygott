#!/bin/bash
set -ev
shopt -s dotglob

export HOME=/home/runner
mkdir -p /opt/homes/default /opt/virtualenvs
rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/default
find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
expected_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"

if [[ -z "${LANGS}" || ",${LANGS}," == *",ballerina,"* ]]; then
	echo 'Setup ballerina'
	cd "${HOME}"

	wget https://dist.ballerina.io/downloads/1.2.6/ballerina-linux-installer-x64-1.2.6.deb
	dpkg -i ballerina-linux-installer-x64-1.2.6.deb
	rm -r ballerina-linux-installer-x64-1.2.6.deb

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for ballerina
		mkdir -p /opt/homes/ballerina
		cp -rp /opt/homes/default/* /opt/homes/ballerina
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/ballerina
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/ballerina
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language ballerina just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",bash,"* ]]; then
	echo 'Setup bash'
	cd "${HOME}"

	cd /tmp && wget --quiet https://github.com/ewiger/beautify_bash/archive/master.tar.gz && tar xfz master.tar.gz && cp beautify_bash-master/beautify_bash.py /bin/ && chmod +x /bin/beautify_bash.py && rm -rf beautify_bash-master && rm -rf master.tar.gz

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for bash
		mkdir -p /opt/homes/bash
		cp -rp /opt/homes/default/* /opt/homes/bash
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/bash
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/bash
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language bash just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",c,"* || ",${LANGS}," == *",cpp,"* || ",${LANGS}," == *",cpp11,"* ]]; then
	echo 'Setup c'
	cd "${HOME}"

	cd /tmp && wget -q https://github.com/cquery-project/cquery/releases/download/v20180302/cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && tar xf cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && cd cquery-v20180302-x86_64-unknown-linux-gnu && cp bin/cquery /bin && cp -r lib/* /lib/ && cd /tmp && rm cquery-v20180302-x86_64-unknown-linux-gnu.tar.xz && rm -r cquery-v20180302-x86_64-unknown-linux-gnu
	update-alternatives --install /usr/bin/clang-format clang-format `which clang-format-7` 100
	mkdir -p /config/cquery && echo -e '%clang\n%c -std=c11\n%cpp -std=c++17\n-pthread' | tee /config/cquery/.cquery

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for c
		mkdir -p /opt/homes/c
		cp -rp /opt/homes/default/* /opt/homes/c
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/c
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/c
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language c just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",clojure,"* ]]; then
	echo 'Setup clojure'
	cd "${HOME}"

	  wget https://download.clojure.org/install/linux-install-1.10.1.478.sh
  chmod +x linux-install-1.10.1.478.sh
  ./linux-install-1.10.1.478.sh
  rm linux-install-1.10.1.478.sh

  # this ensures that we cache the maven deps in the image ($XDG_CONFIG_HOME)
  # https://clojure.org/reference/deps_and_cli#_command_line_tools
  # pretty ridiculous but what else can you do?
  clojure -Sverbose -Sdeps '{:mvn/local-repo "/home/runner/.m2/repository"}' --eval ''
  mv /home/runner/.m2/repository "${XDG_CONFIG_HOME}/clojure/repository"
  rm -rf /home/runner/.m2
  /usr/bin/build-prybar-lang.sh clojure

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for clojure
		mkdir -p /opt/homes/clojure
		cp -rp /opt/homes/default/* /opt/homes/clojure
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/clojure
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/clojure
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language clojure just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",dart,"* ]]; then
	echo 'Setup dart'
	cd "${HOME}"

	ln -s /usr/lib/dart/bin/pub /usr/local/bin/pub

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for dart
		mkdir -p /opt/homes/dart
		cp -rp /opt/homes/default/* /opt/homes/dart
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/dart
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/dart
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language dart just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",deno,"* ]]; then
	echo 'Setup deno'
	cd "${HOME}"

	curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr sh -s v1.7.0

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for deno
		mkdir -p /opt/homes/deno
		cp -rp /opt/homes/default/* /opt/homes/deno
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/deno
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/deno
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language deno just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",elisp,"* ]]; then
	echo 'Setup elisp'
	cd "${HOME}"

	git clone https://github.com/cask/cask.git /usr/local/cask
	ln -s /usr/local/cask/bin/cask /usr/local/bin/cask
	cask upgrade-cask
	/usr/bin/build-prybar-lang.sh elisp

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for elisp
		mkdir -p /opt/homes/elisp
		cp -rp /opt/homes/default/* /opt/homes/elisp
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/elisp
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/elisp
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language elisp just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",enzyme,"* || ",${LANGS}," == *",gatsbyjs,"* || ",${LANGS}," == *",jest,"* || ",${LANGS}," == *",nextjs,"* || ",${LANGS}," == *",nodejs,"* || ",${LANGS}," == *",react_native,"* || ",${LANGS}," == *",reactjs,"* || ",${LANGS}," == *",reactts,"* ]]; then
	echo 'Setup nodejs'
	cd "${HOME}"

	npm install -g jest@23.1.0 prettier@1.13.4 babylon@6.15 babel-traverse@6.21 walker@1.0.7 yarn
	yarn global add jest
	/usr/bin/build-prybar-lang.sh nodejs

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for nodejs
		mkdir -p /opt/homes/nodejs
		cp -rp /opt/homes/default/* /opt/homes/nodejs
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/nodejs
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/nodejs
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language nodejs just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",enzyme,"* ]]; then
	echo 'Setup parents of enzyme'
	find /opt/homes/nodejs/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup enzyme'
	cd "${HOME}"

	yarn add react react-dom react-addons-test-utils jsdom enzyme babel-core babel-preset-latest babel-preset-react babel-polyfill

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for enzyme
		mkdir -p /opt/homes/enzyme
		cp -rp /opt/homes/default/* /opt/homes/enzyme
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/enzyme
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/enzyme
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language enzyme just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",flow,"* ]]; then
	echo 'Setup flow'
	cd "${HOME}"

	npm install -g flow-language-server-amasad flow-bin

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for flow
		mkdir -p /opt/homes/flow
		cp -rp /opt/homes/default/* /opt/homes/flow
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/flow
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/flow
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language flow just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",forth,"* ]]; then
	echo 'Setup forth'
	cd "${HOME}"

	  pushd /tmp
  wget -O gforth-0.7.9.tar.xz http://www.complang.tuwien.ac.at/forth/gforth/Snapshots/0.7.9_20200716/gforth-0.7.9_20200716.tar.xz
  tar -Jxf gforth-0.7.9.tar.xz
  rm gforth-0.7.9.tar.xz
  mv gforth-0.7.9_* gforth-0.7.9
  cd gforth-0.7.9

  cd unix
  [ -e stat-fsi.c ] || wget -O stat-fsi.c https://git.savannah.gnu.org/cgit/gforth.git/plain/unix/stat-fsi.c
  gcc stat-fsi.c -o stat-fsi
  ./stat-fsi > stat.fs
  cd ..

  ./autogen.sh
  ./configure
  make
  make more
  make install
  cd ..
  rm -rf /tmp/gforth-0.7.9
  popd

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for forth
		mkdir -p /opt/homes/forth
		cp -rp /opt/homes/default/* /opt/homes/forth
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/forth
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/forth
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language forth just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",gatsbyjs,"* ]]; then
	echo 'Setup parents of gatsbyjs'
	find /opt/homes/nodejs/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup gatsbyjs'
	cd "${HOME}"

	rm -f /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout
	npm install -g gatsby-cli
	gatsby new /home/runner && rm LICENSE && rm README.md && rm .prettierrc && rm .gitignore
	yarn

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for gatsbyjs
		mkdir -p /opt/homes/gatsbyjs
		cp -rp /opt/homes/default/* /opt/homes/gatsbyjs
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/gatsbyjs
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/gatsbyjs
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language gatsbyjs just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",go,"* ]]; then
	echo 'Setup go'
	cd "${HOME}"

	cd /tmp && wget -q https://golang.org/dl/go1.14.7.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.14.7.linux-amd64.tar.gz && rm go1.14.7.linux-amd64.tar.gz
	/usr/local/go/bin/go get -u github.com/saibing/bingo

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for go
		mkdir -p /opt/homes/go
		cp -rp /opt/homes/default/* /opt/homes/go
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/go
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/go
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language go just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",haxe,"* ]]; then
	echo 'Setup haxe'
	cd "${HOME}"

	pushd /tmp
	curl --output hashlink.tar.gz -ks https://codeload.github.com/HaxeFoundation/hashlink/tar.gz/1.11
	tar -xz --file=hashlink.tar.gz
	rm hashlink.tar.gz
	cd hashlink-1.11
	sed -i '92s|.*|LFLAGS += -lm -Wl,-rpath,.:'$ORIGIN/../lib':$(PREFIX)/lib -Wl,--export-dynamic -Wl,--no-undefined|' Makefile
	make all
	make install
	cd ..
	rm -rf hashlink-1.11
	popd
	haxelib setup /home/runner

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for haxe
		mkdir -p /opt/homes/haxe
		cp -rp /opt/homes/default/* /opt/homes/haxe
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/haxe
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/haxe
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language haxe just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",java,"* ]]; then
	echo 'Setup java'
	cd "${HOME}"

	mkdir -p /config/language-server && cd /config/language-server && wget http://download.eclipse.org/jdtls/milestones/0.21.0/jdt-language-server-0.21.0-201806152234.tar.gz && tar -xzf jdt-language-server-0.21.0-201806152234.tar.gz && rm jdt-language-server-0.21.0-201806152234.tar.gz && chown runner:runner -R /config/language-server
	echo '<project> <modelVersion>4.0.0</modelVersion> <groupId>mygroupid</groupId> <artifactId>myartifactid</artifactId> <version>0.0-SNAPSHOT</version> <build><plugins> <plugin> <groupId>de.qaware.maven</groupId> <artifactId>go-offline-maven-plugin</artifactId> <version>1.2.5</version> <configuration> <dynamicDependencies> <DynamicDependency> <groupId>org.apache.maven.surefire</groupId> <artifactId>surefire-junit4</artifactId> <version>2.20.1</version> <repositoryType>PLUGIN</repositoryType> </DynamicDependency> <DynamicDependency> <groupId>com.querydsl</groupId> <artifactId>querydsl-apt</artifactId> <version>4.2.1</version> <classifier>jpa</classifier> <repositoryType>MAIN</repositoryType> </DynamicDependency> </dynamicDependencies> </configuration> </plugin> </plugins></build> </project>' > /tmp/emptypom.xml
	mvn -f /tmp/emptypom.xml -Dmaven.repo.local=/home/runner/.m2/repository de.qaware.maven:go-offline-maven-plugin:resolve-dependencies dependency:copy-dependencies
	rm /tmp/emptypom.xml

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for java
		mkdir -p /opt/homes/java
		cp -rp /opt/homes/default/* /opt/homes/java
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/java
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/java
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language java just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",julia,"* ]]; then
	echo 'Setup julia'
	cd "${HOME}"

	wget https://julialang-s3.julialang.org/bin/linux/x64/1.3/julia-1.3.1-linux-x86_64.tar.gz
	tar xf julia-1.3.1-linux-x86_64.tar.gz
	cp julia-1.3.1/bin/julia /usr/bin/
	cp -r julia-1.3.1/lib/* /usr/lib/
	cp -r julia-1.3.1/include/* /usr/include/
	cp -r julia-1.3.1/share/* /usr/share/
	rm -rf ./julia-1.3.1 julia-1.3.1-linux-x86_64.tar.gz
	/usr/bin/build-prybar-lang.sh julia

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for julia
		mkdir -p /opt/homes/julia
		cp -rp /opt/homes/default/* /opt/homes/julia
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/julia
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/julia
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language julia just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",kotlin,"* ]]; then
	echo 'Setup kotlin'
	cd "${HOME}"

	wget https://github.com/JetBrains/kotlin/releases/download/v1.3.72/kotlin-compiler-1.3.72.zip -O /tmp/a.zip
	unzip /tmp/a.zip -d /opt
	rm /tmp/a.zip
	ln -s /opt/kotlinc/bin/kotlin{,c,c-js,c-jvm} /usr/local/bin/

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for kotlin
		mkdir -p /opt/homes/kotlin
		cp -rp /opt/homes/default/* /opt/homes/kotlin
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/kotlin
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/kotlin
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language kotlin just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",lua,"* ]]; then
	echo 'Setup lua'
	cd "${HOME}"

	luarocks install formatter && luarocks install metalua && luarocks install penlight
	/usr/bin/build-prybar-lang.sh lua

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for lua
		mkdir -p /opt/homes/lua
		cp -rp /opt/homes/default/* /opt/homes/lua
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/lua
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/lua
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language lua just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",nextjs,"* ]]; then
	echo 'Setup parents of nextjs'
	find /opt/homes/nodejs/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup nextjs'
	cd "${HOME}"

	mkdir -p /home/runner/pages

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for nextjs
		mkdir -p /opt/homes/nextjs
		cp -rp /opt/homes/default/* /opt/homes/nextjs
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/nextjs
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/nextjs
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language nextjs just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",nim,"* ]]; then
	echo 'Setup nim'
	cd "${HOME}"

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

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for nim
		mkdir -p /opt/homes/nim
		cp -rp /opt/homes/default/* /opt/homes/nim
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/nim
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/nim
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language nim just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",objective-c,"* ]]; then
	echo 'Setup objective-c'
	cd "${HOME}"

	export LIBOBJC2=https://codeload.github.com/gnustep/libobjc2/tar.gz/v2.0
export GNUSTEP_SOURCES=(
	ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-2.8.0.tar.gz
	ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-1.27.0.tar.gz
	ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-0.28.0.tar.gz
	ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-0.28.0.tar.gz
)

# Create temporary directory
mkdir /tmp/gnustep-dev && cd /tmp/gnustep-dev

# Use clang
export CC=clang-8
export CXX=clang++-8

# Install libobjc2
export LIBOBJC2_NAME=libobjc2-2.0
curl --output ${LIBOBJC2_NAME}.tar.gz -ks $LIBOBJC2
tar -xz --file=${LIBOBJC2_NAME}.tar.gz
cd $LIBOBJC2_NAME
mkdir Build && cd Build
cmake ..
make -j8
make install
cd ../..

# Install GNUStep from source
export GNUSTEP_MAKEFILES=/usr/local/share/GNUstep/Makefiles
for dl in "${GNUSTEP_SOURCES[@]}"; do
	export pkg=$(basename ${dl##*/} .tar.gz)
	echo '---Downloading '${pkg}'---'
	(
		curl -ks ${dl} | tar vzx && cd ${pkg} || exit $?
		{
			./configure
			make -j8
			make install
			ldconfig
			. /usr/local/share/GNUstep/Makefiles/GNUstep.sh
		}
	) || exit $?
done

# Reinstall libdispatch-dev
cd /tmp/gnustep-dev
git clone https://github.com/plaurent/libdispatch.git
cd libdispatch
rm -Rf build
mkdir build && cd build
../configure  --prefix=/usr
make
make install
ldconfig

# Remove temporary directory
rm -rf /tmp/gnustep-dev

cd $HOME
	

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for objective-c
		mkdir -p /opt/homes/objective-c
		cp -rp /opt/homes/default/* /opt/homes/objective-c
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/objective-c
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/objective-c
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language objective-c just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",ocaml,"* ]]; then
	echo 'Setup ocaml'
	cd "${HOME}"

	opam init -c ocaml-system -n --disable-sandboxing
	/usr/bin/build-prybar-lang.sh ocaml

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for ocaml
		mkdir -p /opt/homes/ocaml
		cp -rp /opt/homes/default/* /opt/homes/ocaml
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/ocaml
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/ocaml
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language ocaml just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",powershell,"* ]]; then
	echo 'Setup powershell'
	cd "${HOME}"

	curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell-7.0.3-linux-x64.tar.gz
	mkdir /usr/local/pwsh
	tar zxf /tmp/powershell.tar.gz -C /usr/local/pwsh
	ln -s -f /usr/local/pwsh/pwsh /usr/bin/pwsh
	ln -s -f /usr/local/pwsh/pwsh /usr/bin/powershell
	rm -f /tmp/powershell.tar.gz

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for powershell
		mkdir -p /opt/homes/powershell
		cp -rp /opt/homes/default/* /opt/homes/powershell
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/powershell
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/powershell
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language powershell just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* || ",${LANGS}," == *",python3,"* || ",${LANGS}," == *",pyxel,"* || ",${LANGS}," == *",quil,"* ]]; then
	echo 'Setup python3'
	cd "${HOME}"

	ln -s /usr/bin/python3.8 /usr/local/bin/python3
	curl https://bootstrap.pypa.io/get-pip.py | python3
	python3 -m venv /opt/virtualenvs/python3
	/opt/virtualenvs/python3/bin/pip3 install --disable-pip-version-check pipreqs-amasad==0.4.10 pylint==2.6.0 jedi==0.17.2 mccabe==0.6.1 pycodestyle==2.6.0 pyflakes==2.2.0 python-language-server==0.36.2 rope==0.18.0 yapf==0.30.0 dephell==0.8.3 poetry==1.1.4
	/opt/virtualenvs/python3/bin/pip3 install poetry==1.0.5 bpython matplotlib nltk numpy ptpython requests scipy replit
	/opt/virtualenvs/python3/bin/pip3 install cs50
	/opt/virtualenvs/python3/bin/pip3 install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-2.2.0-cp38-cp38-manylinux2010_x86_64.whl
	/opt/virtualenvs/python3/bin/python3 -m pip uninstall -y typing
	/usr/bin/build-prybar-lang.sh python3

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for python3
		mkdir -p /opt/homes/python3
		cp -rp /opt/homes/default/* /opt/homes/python3
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/python3
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/python3
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language python3 just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",pygame,"* ]]; then
	echo 'Setup parents of pygame'
	find /opt/homes/python3/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup pygame'
	cd "${HOME}"

	/opt/virtualenvs/python3/bin/python3 -m pip install pygame
	/opt/virtualenvs/python3/bin/python3 -m pip uninstall -y typing

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for pygame
		mkdir -p /opt/homes/pygame
		cp -rp /opt/homes/default/* /opt/homes/pygame
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/pygame
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/pygame
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language pygame just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",python,"* ]]; then
	echo 'Setup python'
	cd "${HOME}"

	pip2 install -U setuptools
	pip2 install -U configparser
	pip2 install --no-cache-dir pipreqs-amasad==0.4.10 jedi==0.12.1 pyflakes==2.0.0 rope==0.11.0 yapf==0.25.0 mccabe==0.6.1 nltk numpy scipy requests matplotlib bpython ptpython

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for python
		mkdir -p /opt/homes/python
		cp -rp /opt/homes/default/* /opt/homes/python
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/python
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/python
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language python just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",pyxel,"* ]]; then
	echo 'Setup parents of pyxel'
	find /opt/homes/python3/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup pyxel'
	cd "${HOME}"

	/opt/virtualenvs/python3/bin/python3 -m pip install glfw
	/opt/virtualenvs/python3/bin/python3 -m pip install git+https://github.com/amasad/pyxel
	/opt/virtualenvs/python3/bin/python3 -m pip uninstall -y typing

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for pyxel
		mkdir -p /opt/homes/pyxel
		cp -rp /opt/homes/default/* /opt/homes/pyxel
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/pyxel
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/pyxel
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language pyxel just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",quil,"* ]]; then
	echo 'Setup parents of quil'
	find /opt/homes/python3/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup quil'
	cd "${HOME}"

	/opt/virtualenvs/python3/bin/pip3 install referenceqvm==0.3 pyquil==1.9.0
	/opt/virtualenvs/python3/bin/python3 -m pip uninstall -y typing

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for quil
		mkdir -p /opt/homes/quil
		cp -rp /opt/homes/default/* /opt/homes/quil
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/quil
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/quil
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language quil just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",raku,"* ]]; then
	echo 'Setup raku'
	cd "${HOME}"

	ln -s /opt/rakudo-pkg/bin/perl6 /usr/local/bin/perl6
	ln -s /opt/rakudo-pkg/bin/raku /usr/local/bin/raku
	ln -s /opt/rakudo-pkg/bin/nqp /usr/local/bin/nqp
	ln -s /opt/rakudo-pkg/bin/moar /usr/local/bin/moar
	ln -s /opt/rakudo-pkg/bin/zef /usr/local/bin/zef
	zef install Linenoise

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for raku
		mkdir -p /opt/homes/raku
		cp -rp /opt/homes/default/* /opt/homes/raku
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/raku
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/raku
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language raku just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",reactjs,"* ]]; then
	echo 'Setup parents of reactjs'
	find /opt/homes/nodejs/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup reactjs'
	cd "${HOME}"

	rm -rf /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout /home/runner/.cache /home/runner/.npm
	npx create-react-app /home/runner/app
	rsync --archive /home/runner/app/ /home/runner
	rm -rf /home/runner/app
	yarn
	rm -f README.md

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for reactjs
		mkdir -p /opt/homes/reactjs
		cp -rp /opt/homes/default/* /opt/homes/reactjs
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/reactjs
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/reactjs
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language reactjs just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",reactts,"* ]]; then
	echo 'Setup parents of reactts'
	find /opt/homes/nodejs/ -mindepth 1 -maxdepth 1 -exec cp -rp {} /home/runner/ \;
	echo 'Setup reactts'
	cd "${HOME}"

	rm -rf /home/runner/.profile /home/runner/.bashrc /home/runner/.bash_logout /home/runner/.cache /home/runner/.npm
	npx create-react-app --scripts-version=react-scripts-ts /home/runner/app
	rsync --archive /home/runner/app/ /home/runner
	rm -rf /home/runner/app
	yarn
	rm -f README.md

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for reactts
		mkdir -p /opt/homes/reactts
		cp -rp /opt/homes/default/* /opt/homes/reactts
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/reactts
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/reactts
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language reactts just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",ruby,"* ]]; then
	echo 'Setup ruby'
	cd "${HOME}"

	gem install --source http://rubygems.org rspec:3.5 stripe rufo sinatra
	gem install solargraph -v 0.38.1
	/usr/bin/build-prybar-lang.sh ruby

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for ruby
		mkdir -p /opt/homes/ruby
		cp -rp /opt/homes/default/* /opt/homes/ruby
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/ruby
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/ruby
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language ruby just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",rust,"* ]]; then
	echo 'Setup rust'
	cd "${HOME}"

	curl --proto '=https' --tlsv1.2 -Sf https://static.rust-lang.org/dist/rust-1.44.0-x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
	/tmp/rust-1.44.0-x86_64-unknown-linux-gnu/install.sh
	rm -rf /tmp/rust-1.44.0-x86_64-unknown-linux-gnu

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for rust
		mkdir -p /opt/homes/rust
		cp -rp /opt/homes/default/* /opt/homes/rust
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/rust
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/rust
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language rust just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",scala,"* ]]; then
	echo 'Setup scala'
	cd "${HOME}"

	wget -nv https://downloads.lightbend.com/scala/2.13.1/scala-2.13.1.tgz
	tar -xf scala-2.13.1.tgz
	cp -R   scala-2.13.1/bin/*     /usr/local/bin/
	cp -R   scala-2.13.1/lib/*     /usr/local/lib/
	rm -rf  scala-2.13.1/
	/usr/bin/build-prybar-lang.sh scala

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for scala
		mkdir -p /opt/homes/scala
		cp -rp /opt/homes/default/* /opt/homes/scala
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/scala
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/scala
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language scala just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",sqlite,"* ]]; then
	echo 'Setup sqlite'
	cd "${HOME}"

	/usr/bin/build-prybar-lang.sh sqlite

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for sqlite
		mkdir -p /opt/homes/sqlite
		cp -rp /opt/homes/default/* /opt/homes/sqlite
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/sqlite
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/sqlite
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language sqlite just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",swift,"* ]]; then
	echo 'Setup swift'
	cd "${HOME}"

	wget https://swift.org/builds/swift-5.0.1-release/ubuntu1804/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
	wget https://swift.org/builds/swift-5.0.1-release/ubuntu1804/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig
	gpg --keyserver hkp://ipv4.pool.sks-keyservers.net         --recv-keys          '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD'          '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F'          'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6'          '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235'          '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4' 'A62A E125 BBBF BB96 A6E0 42EC 925C C1CC ED3D 1561' '8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA'
	gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --refresh-keys
	gpg --verify swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig || exit 1
	tar xzvf swift-5.0.1-RELEASE-ubuntu18.04.tar.gz --strip-components=1 -C /
	rm swift-5.0.1-RELEASE-ubuntu18.04.tar.gz
	rm swift-5.0.1-RELEASE-ubuntu18.04.tar.gz.sig
	chmod -R go+r /usr/lib/swift
	swift --version

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for swift
		mkdir -p /opt/homes/swift
		cp -rp /opt/homes/default/* /opt/homes/swift
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/swift
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/swift
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language swift just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",tcl,"* ]]; then
	echo 'Setup tcl'
	cd "${HOME}"

	cp /gocode/src/github.com/replit/prybar/languages/tcl/tcl.pc /usr/lib/pkgconfig/tcl.pc
	/usr/bin/build-prybar-lang.sh tcl

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for tcl
		mkdir -p /opt/homes/tcl
		cp -rp /opt/homes/default/* /opt/homes/tcl
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/tcl
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/tcl
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language tcl just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",webassembly,"* ]]; then
	echo 'Setup WebAssembly'
	cd "${HOME}"

	wget https://github.com/wasmerio/wasmer/releases/download/0.14.0/wasmer-linux-amd64.tar.gz -O /tmp/wasmer.tar.gz
	mkdir /usr/local/wasmer
	tar -xvf /tmp/wasmer.tar.gz -C /usr/local/wasmer --strip-components=1
	ln -s /usr/local/wasmer/wasmer /usr/local/bin/wasmer
	rm /tmp/wasmer.tar.gz

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for WebAssembly
		mkdir -p /opt/homes/WebAssembly
		cp -rp /opt/homes/default/* /opt/homes/WebAssembly
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/WebAssembly
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/WebAssembly
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language WebAssembly just touched the apt lists!'
		exit 1
	fi
fi

if [[ -z "${LANGS}" || ",${LANGS}," == *",wren,"* ]]; then
	echo 'Setup wren'
	cd "${HOME}"

	wget https://github.com/wren-lang/wren-cli/releases/download/0.3.0/wren_cli-linux-0.3.0.zip
	unzip wren_cli-linux-0.3.0.zip
	install wren_cli-linux-0.3.0/wren_cli /usr/local/bin
	rm -rf wren_cli-linux-0.3.0

	if [[ -n "$(ls -A /home/runner)" ]]; then
		echo Storing home for wren
		mkdir -p /opt/homes/wren
		cp -rp /opt/homes/default/* /opt/homes/wren
		rsync --archive --no-specials --no-devices /home/runner/ /opt/homes/wren
		find /home/runner/ -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
		ls -A /opt/homes/wren
	fi
	last_mtime="$(find /var/lib/apt/lists -type f -print0 | xargs -0 stat --format="%Y" | sort -n | tail -n1)"
	if [[ "${last_mtime}" != "${expected_mtime}" ]]; then
		echo 'Language wren just touched the apt lists!'
		exit 1
	fi
fi


chown runner:runner -R /home/runner /opt/homes /config /opt/virtualenvs
cp -rp /opt/homes/default/* /home/runner
if [[ -n "$(ls /tmp/)" ]]; then
	rm -rf /tmp/*
fi

rm -rf /var/lib/apt/lists/*
rm /phase2.sh
