import os
import glob
import pytoml as toml
import base64

whitelist = ['python3','nodejs']

packages = ['curl', 'wget', 'gnupg', 'build-essential', 'man']
setup = []
run = []
setup_dupes = []
tests = []

def sh(args):
	return ' '.join(args)

list = glob.glob("./languages/*.toml")
list.sort()
for conf in list:
	with open(conf, "r") as file:
		info = toml.load(file)
		name = info['name']
		if name not in whitelist:
			#continue
			pass

		if 'tests' in info:
			for tname, test in info['tests'].items():
				tests.append(' | '.join([
					'echo "' + base64.b64encode(test['code'].encode('utf-8')).decode("ascii") + '" ',
					'base64 --decode',
					'docker run --rm -i polygott run-project -s -l ' + name,
					'diff -u --label ' + name + ' <( echo "' + base64.b64encode(test['output'].encode('utf-8')).decode("ascii") + '" | base64 --decode ) -'
				]) + ' && echo ✓ ' + name + ':' + tname)
		else:
			print("Warining %s has no tests" % (name))

		run.append(name + ")")
		run.append('  maybe_read_stdin ' + info['entrypoint'])
		if 'compile' in info:
			run.append("  " + sh(info['compile']['command']) + " " + info['entrypoint'])			
		if 'run' in info:
			run.append("  " + sh(info['run']['command']))
		run.append('  ;;')

		if 'packages' in info:
			packages += info['packages']

		if 'setup' in info:
			setup.append("echo Setup " + name)
			for line in info['setup']:
				if line in setup_dupes:
					setup.append("#" + line)
				else:
					setup.append(line)
					setup_dupes.append(line)
			setup.append("")
			setup.append("if [ -n \"$(ls -A /home/runner)\" ]; then")
			setup.append("\techo Storing home for " + name)
			setup.append("\tmkdir -p /opt/homes/" + name)
			setup.append("\tcp -r /opt/homes/default/* /opt/homes/" + name)
			setup.append("\tmv -nt /opt/homes/" + name + "/ /home/runner/*")
			setup.append("\tls -A /opt/homes/" + name)
			setup.append("fi")
			setup.append("")
			setup.append("")





packages = set(packages)

sout = open("out/setup.sh", "w")

sout.write('''#!/bin/bash
set -v
shopt -s dotglob

groupadd -g 1000 runner
useradd -m -d /home/runner -g runner -s /bin/bash runner --uid 1000 --gid 1000

apt-get update
''')

sout.write("DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends " + ' '.join(packages))

sout.write("\n\n")
sout.write('''
curl -sL https://deb.nodesource.com/setup_10.x | bash -
DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
npm install -g yarn

cd /home/runner
mkdir -p /opt/homes/default
mv -nt /opt/homes/default/ $(ls -A /home/runner)

''')
sout.write('\n\n')
sout.write('\n'.join(setup))

sout.write('''

cp -r /opt/homes/default/* /home/runner
chown runner:runner -R /home/runner

rm -rf /var/lib/apt/lists/*
chmod +x /usr/bin/run-project
rm /setup.sh
''')

sout.close()


srun = open("out/run-project", "w")
srun.write('''#!/bin/bash
READ_STDIN=0
LANGUAGE=python3

while getopts ":sl:" opt; do
  case ${opt} in
    s )
      READ_STDIN=1
      ;;
    l )
      LANGUAGE=$OPTARG
      ;;
    \? )
      echo "Usage: run-project [-s] [-l language]"
      exit 1
      ;;
  esac
done

maybe_read_stdin() {
    if $READ_STIN; then
        cat - > /home/runner/$1
    fi
}

''')
srun.write("case $LANGUAGE in\n")
srun.write('\n'.join(run))
srun.write('''

*)
  echo "Unknown Language: $LANGUAGE"
  ;;
esac

''')
srun.close()

stest = open("test.sh", "w")
stest.write('''#!/bin/bash

''')
stest.write('\n'.join(tests))
stest.close()
