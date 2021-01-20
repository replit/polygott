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

let aptKeys = {};
let aptKeyUrls = {};
let aptRepos = {};
let packages = {};

let list = glob.sync(path.join(base, "languages", "*.toml"));
let languages = [];
let handledLanguages = {};
list.sort();

let dc = [];
function undup(line) {
	if (dc.indexOf(line) != -1) {
		return `# undup:${line}`;
	}
	dc.push(line);
	return line;
}

function handleLanguage(language, dependency = false) {
	if (language in handledLanguages) {
		return;
	}

	let file = path.join(base, "languages", language + ".toml");
	let info = toml.parse(fs.readFileSync(file, "utf8"));

	let result = tv4.validateMultiple(info, schema);
	if (!result.valid) {
		console.log(`Warning: ${file} schema invalid.`);
		for (let error of result.errors) {
			console.log(`-> ${error.message} @ ${error.dataPath}`);
		}
		process.exit(1);
	}

	let name = info.name;
	info.id = path.basename(file).replace(/.toml$/, '');
	let names = [name, info.id];
	if (info.aliases) {
		names = names.concat(info.aliases);
	};
	info.names = [...new Set(names)];
	if (process.env.LANGS) {
		let set = process.env.LANGS.split(/[ ,]+/);
		if (set.indexOf(info.id) == -1 && !dependency) return;
	}

	if (info.languages) {
		for (let l of info.languages) {
			handleLanguage(l, true);
		}
	}

	info.popularity = info.popularity || 2;

	if (!info.versionCommand) {
		let flag = "--version";
		if (["lua"].indexOf(info.name) !== -1) {
			flag = "-v";
		}

		if (["go"].indexOf(info.name) !== -1) {
			flag = "version";
		}

		if (["java"].indexOf(info.name) !== -1) {
			flag = "-version";
		}

		if (info.compile) {
			info.versionCommand = [info.compile.command[0], flag];
		} else if (info.run) {
			info.versionCommand = [info.run.command[0], flag];
		} else {
			info.versionCommand = ["/bin/false"];
		}
	}

	if ("tests" in info) {
	} else {
		console.log(`Warning ${name} has no tests.`);
		info.tests = {};
	}

	if (info.aptKeys) {
		for (let p of info.aptKeys) {
			if (!aptKeys[p]) {
				aptKeys[p] = [];
			}
			aptKeys[p].push(info.id);
		}
	}

	if (info.aptKeyUrls) {
		for (let p of info.aptKeyUrls) {
			if (!aptKeyUrls[p]) {
				aptKeyUrls[p] = [];
			}
			aptKeyUrls[p].push(info.id);
		}
	}

	if (info.aptRepos) {
		for (let p of info.aptRepos) {
			if (!aptRepos[p]) {
				aptRepos[p] = [];
			}
			aptRepos[p].push(info.id);
		}
	}

	if (info.packages) {
		for (let p of info.packages) {
			if (basePackages.indexOf(p) != -1) continue;
			if (!packages[p]) {
				packages[p] = [];
			}
			packages[p].push(info.id);
		}
	}
	languages.push(info);
	handledLanguages[language] = true;
}

for (let file of list) {
	let language = path.basename(file, ".toml");
	handleLanguage(language);
}

let lbypop = JSON.parse(JSON.stringify(languages));
lbypop.sort((a, b) => b.popularity - a.popularity);

let lpad = (s, n) => s + new Array(n - s.length).fill(" ").join("");

let ctx = {
	basePackages,
	languages,
	btoa,
	lbypop,
	packages,
	aptRepos,
	aptKeys,
	aptKeyUrls,
	undup,
	lpad,
	c: a => a.map((s) => {
		if (/^(\S*|`[^`]+`)$/.test(s)) return s;
		return `'${s.replace(/[$'\\]/g, (m) => '\\' + m)}'`;
	}).join(" ")
};

let objects = {
	"test.sh": "tests.ejs",
	"self-test": "self-test.ejs",
	"phase0.sh": "phase0.ejs",
	"phase1.sh": "phase1.ejs",
	"phase2.sh": "phase2.ejs",
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
