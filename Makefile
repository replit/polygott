# Note that the '##' syntax is important, since it is parsed by the
# 'make help' target below.

# Default task:
.PHONY: image
image: out/.gen.stamp ## Build Docker image with all languages
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		-t polygott:latest .

.PHONY: image-ci
image-ci: out/.gen.stamp ## Build Docker image with all languages needed for CI
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		--build-arg LANGS=python3,ruby,java \
		-t polygott-ci:latest .

out/.gen.stamp: $(wildcard gen/*.*) $(wildcard languages/*.toml)
	rm -rf out/ && mkdir out
	(cd gen && npm install) && node gen/index.js
	touch $@

image-%: languages/%.toml out/.gen.stamp ## Build Docker image with single language LANG
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		--build-arg LANGS=$(*) \
		-t polygott-$(*) .

.PHONY: run
run: image ## Build and run image with all languages
	DOCKER_BUILDKIT=1 docker run -it --rm \
		polygott

.PHONY: run-lang
run-lang:

run-%: image-% run-lang ## Build and run image with single language LANG
	DOCKER_BUILDKIT=1 docker run -it --rm \
		"polygott-$(*)"

.PHONY: test
test: image ## Build and test all languages
	DOCKER_BUILDKIT=1 docker run \
		polygott:latest \
		bash -c polygott-self-test

.PHONY: test-ci
test-ci: image-ci ## Build and test all languages needed for CI
	DOCKER_BUILDKIT=1 docker run \
		polygott-ci:latest \
		env LANGS=python3,ruby,java \
		bash -c polygott-self-test

.PHONY: test-lang
test-lang:

test-%: image-% test-lang ## Build and test single language LANG
	DOCKER_BUILDKIT=1 docker run \
		"polygott-$(*)" \
		env "LANGS=$(*)" \
		bash -c polygott-self-test

.PHONY: changed-test
changed-test: $(addprefix test-,$(basename $(notdir $(shell git diff --name-only origin/master -- languages)))) ## Build and test only changed/added languages
	# You should still do `make test` to have confidence everything works together.
	# This is a way to catch some failures faster.

.PHONY: help
help: ## Show this message
	@echo "usage:" >&2
	@grep -h "[#]# " $(MAKEFILE_LIST) | \
		sed 's/^/  make /'       | \
		sed 's/:[^#]*[#]# /|/'   | \
		sed 's/%/LANG/'          | \
		column -t -s'|' >&2
