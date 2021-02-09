const fs = require("fs");
const path = require("path");
const glob = require("glob");
const toml = require("toml");
const ejs = require("ejs");
const tv4 = require("tv4");

const base = path.join(__dirname, "..");
const dest = path.join(base, "out");
const schema = require("./schema.json");


const btoa = b => Buffer.from(b).toString("base64");

const basePackages = fs
	.readFileSync(path.join(base, "packages.txt"), "utf8")
	.split(/\r?\n/)
	.filter(x => !/^#|^\s*$/.test(x));
basePackages.sort();

console.log(basePackages);

const aptKeys = {};
const aptKeyUrls = {};
const aptRepos = {};
const packages = {};

// TODO: Move this to a configuration file instead of having it here.
const env = {
	APT_OPTIONS: '-o debug::nolocking=true -o dir::cache=/tmp/apt/cache -o dir::state=/tmp/apt/state -o dir::etc::sourcelist=/tmp/apt/sources/sources.list',
	CPATH: '/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu',
	CPPPATH: '/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu',
	DISPLAY: ':0',
	HOME: '/home/runner',
	INCLUDE_PATH: '/home/runner/.apt/usr/include:/home/runner/.apt/usr/include/x86_64-linux-gnu',
	LANG: 'en_US.UTF-8',
	LC_ALL: 'en_US.UTF-8',
	LD_LIBRARY_PATH: '/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/usr/local/lib:/home/runner/.apt/usr/lib',
	LIBRARY_PATH: '/home/runner/.apt/usr/lib/x86_64-linux-gnu:/home/runner/.apt/usr/lib/i386-linux-gnu:/usr/local/lib:/home/runner/.apt/usr/lib',
	PATH: '/usr/local/go/bin:/opt/virtualenvs/python3/bin:/usr/GNUstep/System/Tools:/usr/GNUstep/Local/Tools:/home/runner/.apt/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	PKG_CONFIG_PATH: '/home/runner/.apt/usr/lib/x86_64-linux-gnu/pkgconfig:/home/runner/.apt/usr/lib/i386-linux-gnu/pkgconfig:/home/runner/.apt/usr/lib/pkgconfig',
	PYTHONPATH: '/opt/virtualenvs/python3/lib/python3.8/site-packages',
	USER: 'runner',
	VIRTUAL_ENV: '/opt/virtualenvs/python3',
};

const languageIds = glob
	.sync(path.join(base, "languages", "*.toml"))
	.map(filename => path.basename(filename, '.toml'))
	.sort();

const languageInfo = languageIds
	.map(languageId => {
		const filepath = path.join(base, "languages", `${languageId}.toml`);
		const info = toml.parse(fs.readFileSync(filepath, 'utf8'));

		const result = tv4.validateMultiple(info, schema);
		if (!result.valid) {
			console.log(`Warning: ${filepath} schema invalid.`);
			for (const error of result.errors) {
				console.log(`-> ${error.message} @ ${error.dataPath}`);
			}
			process.exit(1);
		}

		info.id = languageId;
		return info;
	}).reduce((result, info) => {
		result[info.id] = info;
		return result;
	}, {});

for (const childLanguage of Object.values(languageInfo)) {
	if (!childLanguage.languages) {
		continue;
	}

	const queue = [].concat(childLanguage.languages);
	while (queue.length) {
		const parentLanguage = languageInfo[queue.shift()];
		if (!parentLanguage.childLanguages) {
			parentLanguage.childLanguages = new Set();
		}
		if (parentLanguage.childLanguages.has(childLanguage.id)) {
			continue;
		}
		parentLanguage.childLanguages.add(childLanguage.id);

		if (parentLanguage.languages) {
			queue.push(...parentLanguage.languages);
		}
	}
}

const languages = [];
const handledLanguages = {};
function handleLanguage(language, dependency = false) {
	if (language.id in handledLanguages) {
		return;
	}

	let name = language.name;
	let names = [name, language.id];
	if (language.aliases) {
		names = names.concat(language.aliases);
	};
	language.names = [...new Set(names)];
	language.popularity = language.popularity || 2;

	for (const parentLanguageId of (language.languages || [])) {
		handleLanguage(languageInfo[parentLanguageId]);
	}

	if (!language.versionCommand) {
		let flag = "--version";
		if (["lua"].indexOf(language.name) !== -1) {
			flag = "-v";
		}

		if (["go"].indexOf(language.name) !== -1) {
			flag = "version";
		}

		if (["java"].indexOf(language.name) !== -1) {
			flag = "-version";
		}

		if (language.compile) {
			language.versionCommand = [language.compile.command[0], flag];
		} else if (language.run) {
			language.versionCommand = [language.run.command[0], flag];
		} else {
			language.versionCommand = ["/bin/false"];
		}
	}

	if (!("tests" in language)) {
		console.log(`Warning ${name} has no tests.`);
		language.tests = {};
	}

	const languageIds = [language.id, ...(language.childLanguages || [])];

	if (language.aptKeys) {
		for (let p of language.aptKeys) {
			if (!aptKeys[p]) {
				aptKeys[p] = [];
			}
			aptKeys[p].push(...languageIds);
		}
	}

	if (language.aptKeyUrls) {
		for (let p of language.aptKeyUrls) {
			if (!aptKeyUrls[p]) {
				aptKeyUrls[p] = [];
			}
			aptKeyUrls[p].push(...languageIds);
		}
	}

	if (language.aptRepos) {
		for (let p of language.aptRepos) {
			if (!aptRepos[p]) {
				aptRepos[p] = [];
			}
			aptRepos[p].push(...languageIds);
		}
	}

	if (language.packages) {
		for (let p of language.packages) {
			if (basePackages.indexOf(p) != -1) continue;
			if (!packages[p]) {
				packages[p] = [];
			}
			packages[p].push(...languageIds);
		}
	}
	languages.push(language);
	handledLanguages[language.id] = true;
}

for (const languageId of languageIds ) {
	handleLanguage(languageInfo[languageId]);
}

// Ensure this is stable-sorted.
const lbypop = JSON.parse(JSON.stringify(languages))
	.map((value, index) => [index, value])
	.sort(([aIndex, aValue], [bIndex, bValue]) => {
		if (aValue.popularity == bValue.popularity) {
			return aIndex - bIndex;
		}
		return bValue.popularity - aValue.popularity;
	})
	.map(([, value]) => value);

let lpad = (s, n) => s + new Array(n - s.length).fill(" ").join("");

let ctx = {
	basePackages,
	languageInfo,
	languages,
	btoa,
	lbypop,
	packages,
	aptRepos,
	aptKeys,
	aptKeyUrls,
	lpad,
	env,
	c: a => a.map((s) => {
		if (/^(\S*|`[^`]+`)$/.test(s)) return s;
		return `'${s.replace(/[$'\\]/g, (m) => '\\' + m)}'`;
	}).join(" ")
};

let objects = {
	"test.sh": "tests.ejs",
	"self-test": "self-test.ejs",
	"phase0.sh": "phase0.ejs",
	"Dockerfile": "Dockerfile.ejs",
	"Dockerfile.splice": "Dockerfile.splice.ejs",
	"languages.d": "languages.d.ejs",
	"languages.json": "languages.json.ejs",
	"run-project": "run-project.ejs",
	"run-language-server": "run-language-server.ejs",
	"detect-language": "detect-language.ejs",
	"polygott-survey": "versions.ejs",
	"polygott-lang-setup": "lang-setup.ejs",
	"polygott-x11-vnc": "x11-vnc.ejs",
};

for (let target in objects) {
	let tp = path.join(dest, target);
	fs.writeFileSync(
		tp,
		ejs.compile(fs.readFileSync(path.join(__dirname, objects[target]), "utf8"))(
			ctx
		),
		"utf8"
	);
	fs.chmodSync(path.join(dest, target), 0o755);
}

const perLangScripts = [
	'self-test',
	'phase2',
];

for (const perLangScript of perLangScripts) {
	const dirname = path.join(dest, `share/polygott/${perLangScript}.d`);
	fs.mkdirSync(dirname, { recursive: true, mode: 0o755 });
	for (const lang of languages) {
		const scriptPath = path.join(dirname, lang.id);
		fs.writeFileSync(
			scriptPath,
			ejs.compile(
				fs.readFileSync(
					path.join(__dirname, `${perLangScript}-per-lang.ejs`),
					'utf8',
				),
			)(
				{
					...ctx,
					lang,
				},
			),
			'utf8'
		);
		fs.chmodSync(scriptPath, 0o755);
	}
}

// Local Variables:
// indent-tabs-mode: t
// js-indent-level: 8
// End:
