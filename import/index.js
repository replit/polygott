const fs = require('fs');
const tomlify = require('tomlify-j0.4');
const parser = require('dockerfile-ast').DockerfileParser;

let names = ''

let extra_pkgs = {
	clojure: ['leiningen'],
	ruby: ['ruby', 'rubygems-integration', 'rake-compiler', 'rubygems'],
	reactre: ['ocaml-native-compilers'],
	csharp: ['mono-runtime','mono-mcs','mono-xbuild','mono-xsp','mono-csharp-shell','libmono-system4.0-cil'],
	fsharp: ['mono-runtime','fsharp','libmono-system4.0-cil'],
	python3: ['python3.7', 'python3-pip'],
	java: ['openjdk-11-jdk'],
	rust: ['rustc', 'cargo', 'rust-gdb'],
	rlang: ['r-base','r-base-dev','r-recommended'],
	lua: ['lua5.1', 'liblua5.1-0','liblua5.1-bitop0', 'lua-socket', 'luarocks'],
	go: ['golang', 'golang-race-detector-runtime'],
	php: ['php-cli', 'php-pear'],
	haskell: ['ghc']
}

let languages = fs.readdirSync('target/languages').map((f) => {
	let data = fs.readFileSync(`target/languages/${f}`, 'utf8');
	let def = eval('(function() { return ' + data + '})()');
	let warmups = def.warmups;
	let i = 0;

	delete def.warmups;
	let tests = {};

	if (warmups)
	for ( let w of warmups ) {
		if ( w.length < 2 ) continue;
		if ( w[0].command != "eval" ) continue;
		if ( w[1].command != "output" ) continue;

		if ( !def.tests ) def.tests = {};
		if ( /hello/i.test(w[1].data) ) name = 'hello';
		else name = String(i);
		tests[name] = {
			code: w[0].data,
			output: w[1].data,
		}

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

	console.log(setup);

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

