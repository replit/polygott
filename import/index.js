const fs = require('fs');
const tomlify = require('tomlify-j0.4');
const parser = require('dockerfile-ast').DockerfileParser;

let names = ''

let extra_pkgs = {
	clojure: ['clojure1.6'],
	ruby: ['ruby', 'rubygems-integration', 'rake-compiler', 'rubygems'],
	reactre: ['ocaml-native-compilers'],
	csharp: ['mono-runtime','mono-mcs','mono-xbuild','mono-xsp','mono-csharp-shell','libmono-system4.0-cil'],
	fsharp: ['mono-runtime','fsharp','libmono-system4.0-cil'],
	python3: ['python3.5', 'python3-pip', 'python3-wheel'],
	python: ['python-wheel'],
	java: ['openjdk-8-jdk'],
	rust: ['rustc', 'cargo', 'rust-gdb'],
	rlang: ['r-base','r-base-dev','r-recommended','littler','r-cran-littler','r-cran-stringr'],
	lua: ['lua5.1', 'liblua5.1-0','liblua5.1-bitop0', 'lua-socket', 'luarocks'],
	go: ['golang', 'golang-race-detector-runtime'],
	php: ['php-cli', 'php-pear'],
	haskell: ['ghc'],
	swift: ['libedit2', 'python2.7-minimal', 'libpython2.7', 'libxml2', 'clang', 'libicu-dev']
}

let languages = fs.readdirSync('target/languages').map((f) => {
	if ( f != "quil.json") return;

	let data = fs.readFileSync(`target/languages/${f}`, 'utf8');
	let def = eval('(function() { return ' + data + '})()');
	let warmups = def.warmups;
	let i = 0;

	delete def.warmups;
	let tests = {};

	if (warmups)
	for ( let w of warmups ) {
		let o = {};
		for ( let j = 0; j < w.length; ++j ) {
			switch ( w[j].command ) {
				case "eval":
					o.code = w[j].data;
					break;
				case "output":
					o.output = w[j].data;
					break;
				case "input":
					o.input = w[j].data;
					break;
			}
		}
		console.log(w, o);

		if ( !o.code || !o.output ) continue;

		if ( !def.tests ) def.tests = {};
		if ( /hello/i.test(o.code) ) name = 'hello';
		else name = String(i);

		tests[name] = o;

	}

	let img = def.image.replace(/^images.repl.it./,'');
	let docker = fs.readFileSync(`target/images/${img}/Dockerfile`, 'utf8');
	let setup = [];
	let packages = [];

	if ( extra_pkgs[def.name]  ) {
		packages = packages.concat(extra_pkgs[def.name]);
	}

	let parts = parser.parse(docker).getInstructions();
	for ( let part of parts ) {
		if ( part.instruction == "RUN" ) {
			let str = part.getArgumentsContent().replace(/\s+/g,' ');
			if ( [
				'groupadd runner',
				'groupadd -f runner',
				'adduser -D runner',
				'apt-get update',
				'userdel node',
				'userdel docker',
				'useradd -m -d /home/runner -g runner -s /bin/bash runner',
				'useradd -m -d /home/runner -g runner -s /bin/bash runner --uid 1000 --gid 1000',
				'useradd -m -d /home/runner -g runner -s /bin/bash --uid 1000 --gid 1000 runner',
				'passwd -l root',
				'apt-get update && apt-get install -y curl wget git subversion mercurial busybox',
				'chown runner:runner -R /home/runner',
			].indexOf(str) !== -1 ) continue;

			let match;

			match = str.match(/^apt-get update && apt-get install -y --no-install-recommends (.*?) && rm -rf \/var\/lib\/apt\/lists/);
			if ( match ) {
				Array.prototype.push.apply(packages, match[1].split(' '));
				continue;
			}

			match = str.match(/^(apt-get update && )?apt-get install -y *(.*?)/);
			if ( match ) {
				Array.prototype.push.apply(packages, match[2].split(' '));
				continue;
			}

			setup.push(str);
		} else if ( part.instruction == "ADD" ) {
			console.log("ADD", part.getArgumentsContent())
		}
	}

	let obj = {
		name: def.name,
		entrypoint: def.entrypoint,
		extensions: [def.extension],
		packages: packages,
		//eval: def.eval,
		compile: def.compile,
		run: def.run,
		//lint: def.lint,
		//format: def.format,
		//template: def.template,
		tests: def.tests,
	};

	if ( def.languageServer ) {
		obj.languageServer = {
			command: def.languageServer.startCommand
		}
	}

	if ( obj.name == "rlang" )  {
		obj.run.command[0] = 'R';
	}

	if ( obj.name == "kotlin" ) {
		Array.prototype.push.apply(setup,[
			'wget https://github.com/JetBrains/kotlin/releases/download/v1.0.3/kotlin-compiler-1.0.3.zip -O /tmp/a.zip',
			'unzip /tmp/a.zip -d /opt',
			'rm /tmp/a.zip',
			'ln -s /opt/kotlinc/bin/kotlin{,c,c-js,c-jvm} /usr/local/bin/'
		]);
	}

	if ( obj.name == "swift" ) {
		let VERSION = '4.1.2'
		let SWIFT_SNAPSHOT = `swift-${VERSION}-RELEASE`;
		let SWIFT_SNAPSHOT_LOWERCASE = `swift-${VERSION}-release`;
		let UBUNTU_VERSION = 'ubuntu16.04';
		let UBUNTU_VERSION_NO_DOTS = 'ubuntu1604';

		Array.prototype.push.apply(setup,[
		`wget https://swift.org/builds/${SWIFT_SNAPSHOT_LOWERCASE}/${UBUNTU_VERSION_NO_DOTS}/${SWIFT_SNAPSHOT}/${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz`,
		`wget https://swift.org/builds/${SWIFT_SNAPSHOT_LOWERCASE}/${UBUNTU_VERSION_NO_DOTS}/${SWIFT_SNAPSHOT}/${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz.sig`,
		`gpg --keyserver hkp://pool.sks-keyservers.net
		      --recv-keys 
		      '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD' 
		      '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F' 
		      'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6' 
		      '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235' 
		      '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4'
		 `.replace(/[\t\n]/g,' '),
		  'gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys',
		  `gpg --verify ${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz.sig || exit 1`,
		  `tar xzvf ${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz --strip-components=1 -C /`,
		  `rm ${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz`,
		  `rm ${SWIFT_SNAPSHOT}-${UBUNTU_VERSION}.tar.gz.sig`,
		  'chmod -R go+r /usr/lib/swift',
		  'swift --version'
		]);
	}

	if ( obj.name == "clojure" ) {
		setup =[
			'# 18.04 has this package, so axe this when we upgrade',
			'wget http://mirrors.kernel.org/ubuntu/pool/universe/l/leiningen-clojure/leiningen_2.8.1-6_all.deb',
			'dpkg -i leiningen_2.8.1-6_all.deb',
			'rm leiningen_2.8.1-6_all.deb'
		];
	}

	if ( setup.length > 0 ) {
		obj.setup = setup;
	}

	if ( Object.keys(tests).length > 0 ) {
		obj.tests = tests;
	}


	fs.writeFileSync(`./languages/${def.name}.toml`, tomlify.toToml(obj, {
		space: 2
	}), 'utf8');

})

