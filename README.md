# Polygott
## Overview

[Repl.it] allows you to quickly get started with any programming
language online. In order to provide this capability, our evaluation
server uses [Docker](https://www.docker.com/) to ensure that all these
languages are installed with the appropriate environment set up.

We previously used a separate Docker image for each language, but
concluded that it was both simpler and more efficient to use a single
image which contains all supported languages simultaneously. The code
necessary to build this combined image, **Polygott**, resides in this
repository.  If you're lost and need some reference, we have 
[a blog](https://blog.repl.it/elisp) where we added elisp.

## Build and run

You can build either the entire image, or a version that is limited to
a single language. The latter is recommended when you are adding or
modifying support for a particular language, since building the entire
image takes an extremely long time. Makefile targets are provided for
each of these cases:

    % make help
    usage:
      make image         Build Docker image with all languages
      make image-LANG    Build Docker image with single language LANG
      make run           Build and run image with all languages
      make run-LANG      Build and run image with single language LANG
      make test          Build and test all languages
      make test-LANG     Build and test single language LANG
      make changed-test  Build and test only changed/added languages
      make help          Show this message

As you can see, there is a facility for testing that languages have
been installed and configured correctly. This involves running
commands which are specified in the languages' configuration files,
and checking that the output is as expected. To debug, you can also
use the `make run` and `make run-LANG` targets to launch shells within
the images.

You may want to bypass Docker's cache temporarily, for example to
debug an intermittent network error while building one of the
languages. To do this, identify the `docker build` command which is
run by the Makefile, and run it yourself with the `--no-cache` flag.

## Language configuration

Each supported language has a
[TOML](https://github.com/toml-lang/toml) file [in the `languages`
subdirectory](languages). The meaningful keys are as follows:

### Mandatory

* `entrypoint`: The name of the file which will be executed on
  [Repl.it] when you press the Run button. This is used in the
  `detect-language` script built into the Polygott image: if a file
  exists with this name, then the project is detected to have this
  language. (Ties are resolved by `popularity`.) It is also used by
  the `run-project` script in order to identify the main file of the
  project.
* `extensions`: List of file extensions (use `"py"`, not `".py"`)
  which files of this language may have. This is used in the
  `detect-language` script built into the Polygott image: if a file
  exists with one of these extensions, then the project is detected to
  have this language. (Ties are resolved by `popularity`.)
* `name`: The name of the language. The TOML file should then be named
  `<name>.toml`. This is also what you pass to the Makefile's
  `image-LANG` and `test-LANG` targets.

### Optional

* `aliases`: List of strings indicating alternate names for the
  language, in addition to `name`. This is used to allow the
  `run-language-server` script to accept `-l c++` in addition to `-l
  cpp`, among other things.
* `aptKeys`: List of PGP key IDs that must be passed to `apt-key` in
  order for the custom `aptRepos` configured to be trusted. For
  example, `"09617FD37CC06B54"`.
* `aptRepos`: List of repository strings that must be passed to
  `add-apt-repository` in order for the custom `packages` configured
  to be available. For example, `"deb
  https://dist.crystal-lang.org/apt crystal main"`.
* `compile`
  * `command`: The full command to compile the `entrypoint` file, as a
    list, including the filename. This is run before the `run`
    command.
* `languageServer`
  * `command`: Command to start an [LSP](https://langserver.org/)
    language server, as a list. This is used in the
    `run-language-server` script built into the Polygott image.
* `packages`: List of additional Ubuntu packages to install for this
  language. (Packages which are required by all or many languages
  should be placed instead [in `packages.txt`](packages.txt).) [Check
  the Ubuntu Bionic package
  listing](https://packages.ubuntu.com/bionic/) to see what your
  options are.
* `popularity`: Floating-point number indicating how popular the
  language is. Defaults to `2.0`. This is used in the
  `detect-language` script built into the Polygott image: if a project
  is detected as more than one language, the winner is chosen by
  comparing popularity scores.
* `run`: Required, unless you provide no `tests` or you have asked to
  `skip` all of them.
  * `command`: The full command to run the `entrypoint` file, as a
    list, including the filename. It is run *after* the `compile`
    command, if one is provided. This is used to run tests.
* `runtimeSetup`: List of shell commands to be run by the
  `polygott-lang-setup` script built into the Polygott image.
* `setup`: List of shell commands to be run [in phase 2 of the build
  process](gen/phase2.ejs), as post-install steps.
* `tests`
  * `TESTNAME`
    * `code`: String to write to the `entrypoint` file before invoking
      the `run` command.
    * `output`: String expected to be written to stdout (**not**
      stderr) by running the code.
    * `skip`: Boolean, optional. If true, then the test is skipped.
      This allows you to easily "comment out" a test if there is
      something wrong with the infrastructure.
* `versionCommand`: A command to output the version of the language,
  as a list of strings. For example, `["kotlin", "-version"]`. This is
  used in the `polygott-survey` command built into the Polygott image.
  (If `versionCommand` is omitted, some heuristics are used to guess
  it.)

## Build process

* [The language configuration files](languages) are validated against
  a [JSON Schema](https://json-schema.org/) specification located [in
  `schema.json`](gen/schema.json).
* [The `.ejs` files in the `gen` directory](gen) are transformed into
  shell scripts using the language configuration via the
  [EJS](https://ejs.co/) templating system. This is done by [a Node.js
  script](gen/index.js) inside the Docker image.
* Languages are installed in several phases. [In phase
  0](gen/phase0.ejs), shared packages [in
  `packages.txt`](packages.txt) are installed. [In phase
  1](gen/phase1.ejs), APT keys and repositories are configured, and
  language-specific packages are installed. [In phase
  2](gen/phase2.ejs), language-specific `setup` commands are run.

## Usage

Aside from all the language executables (`python3`, `ruby`, `rust`,
etc.), there are several additional scripts available within the
Docker image. They are documented below.

    polygott-self-test

Run the tests defined in each language's configuration file, as in
`make test` or `make test-LANG`. Always run all the tests, but if one
of them fails, exit with a non-zero return code.

    polygott-survey

Run the `versionCommand` specified for every language, and output the
results in tabular format to stdout.

    polygott-lang-setup [-l LANG]

Copy the contents of `/opt/homes/LANG/` to `/home/runner/`, and run
the `runtimeSetup` commands for it, if any were provided. `LANG`
defaults to the output of `detect-language`.

    detect-language

Try to identify the language used by the project in the current
directory. This first checks if the `entrypoint` file exists for any
language, and then checks if a file with any of the registered
`extensions` exists for a language. If multiple languages match in
either of those two phases, then the `popularity` of the two languages
is used to resolve ties.

Output the language name to `stdout` if one is detected, otherwise do
nothing.

    run-project [-s] [-b] [-l LANG]

Execute the `compile` and `run` commands on the `entrypoint` file in
the current directory. `LANG` defaults to the output of
`detect-language`. If `-s` is passed, then the `entrypoint` file is
written with the contents of stdin. If `-b` is passed, then some
special logic is used instead of the `compile` and `run` commands;
[see the source for details](gen/run-project.ejs).

    run-language-server [-l LANG]

Run the `languageServer` command configured in the language's
configuration file. `LANG` defaults to the output of
`detect-language`.

    polygott-x11-vnc

Start VNC forwarding for X11. Fork into the background and return.
This script does not interact with language configuration at all.

## Deployment

When a commit is merged to `master`, [CircleCI](https://circleci.com/)
automatically builds Polygott and pushes the image to [Docker
Hub](https://hub.docker.com/r/replco/polygott), whence our evaluation
server pulls it.

[repl.it]: https://repl.it/
