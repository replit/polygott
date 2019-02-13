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

let packages = fs
	.readFileSync(path.join(base, "packages.txt"), "utf8")
	.split(/\r?\n/);

let aptRepos = [];

let list = glob.sync(path.join(base, "languages", "*.toml"));
let languages = [];
list.sort();

let dc = [];
function undup(line) {
	if (dc.indexOf(line) == -1) {
		dc.push(line);
		return line;
	} else {
		return "#" + line;
	}
}

for (let file of list) {
	let info = toml.parse(fs.readFileSync(file, "utf8"));

	let result = tv4.validateMultiple(info, schema);
	if ( !result.valid ) {
		console.log(`Warning: ${file} schema invalid.`);
		for ( let error of result.errors ) {
			console.log(`-> ${error.message} @ ${error.dataPath}`)
		}
	}

	let name = info.name;

	if (process.env.LANGS) {
		let set = process.env.LANGS.split(/[ ,]+/);
		if (set.indexOf(name) == -1) continue;
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

	if (info.aptRepos) {
		for (let p of info.aptRepos) {
			if (aptRepos.indexOf(p) == -1) aptRepos.push(p);
		}
	}

	if (info.packages) {
		for (let p of info.packages) {
			if (packages.indexOf(p) == -1) packages.push(p);
		}
	}
	languages.push(info);
}

let lbypop = JSON.parse(JSON.stringify(languages));
lbypop.sort((a, b) => b.popularity - a.popularity);

let lpad = (s, n) => s + new Array(n - s.length).fill(" ").join("");

let ctx = {
	languages,
	btoa,
	lbypop,
	packages,
	aptRepos,
	undup,
	lpad,
	c: a => a.map((s) => {
		if ( /^[a-zA-Z0-9-]*$/.test(s) ) return s;
		return `'${s.replace(/['\\]/g,(m) => '\\' + m)}'`;
	}).join(" ")
};

let objects = {
	"test.sh": "tests.ejs",
	"self-test": "inside-test.ejs",
	"phase1.sh": "phase1.ejs",
	"phase2.sh": "phase2.ejs",
	"run-project": "run-project.ejs",
	"run-language-server": "run-language-server.ejs",
	"detect-language": "detect-language.ejs",
	"polygott-survey": "versions.ejs"
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
