# Note that the '##' syntax is important, since it is parsed by the
# 'make help' target below.

# Default task:
.PHONY: image
image: stamps/image ## Build Docker image with all languages
	# Invoking the underlying build rule for image (if needed).

stamps/:
	mkdir "$@"

stamps/image: out/Dockerfile | stamps/
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		-f out/Dockerfile \
		-t polygott:latest \
		.
	touch "$@"

.PHONY: image-ci
image-ci: stamps/image-ci ## Build Docker image with all languages needed for CI
	# Invoking the underlying build rule for image-ci (if needed).

stamps/image-ci: out/Dockerfile | stamps/
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		--build-arg LANGS=python3,ruby,java \
		-f out/Dockerfile \
		-t polygott-ci:latest \
		.
	touch "$@"

out/Dockerfile: $(wildcard gen/*.*) $(wildcard languages/*.toml)
	rm -rf out/ && mkdir out
	(cd gen && npm install) && node gen/index.js

image-%: stamps/image-% ## Build Docker image with single language LANG
	# Invoking the underlying build rule for image-$(*) (if needed).

stamps/image-%: languages/%.toml out/Dockerfile | stamps/ ## Build Docker image with single language LANG
	DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		--build-arg LANGS=$(*) \
		-f out/Dockerfile \
		-t polygott-$(*) \
		.
	touch "$@"

.PHONY: run
run: stamps/image ## Build and run image with all languages
	docker run -it --rm \
		polygott

run-%: stamps/image-% ## Build and run image with single language LANG
	docker run -it --rm \
		"polygott-$(*)"

.PHONY: test
test: stamps/image ## Build and test all languages
	docker run --rm \
		polygott:latest \
		bash -c polygott-self-test

.PHONY: test-ci
test-ci: stamps/image-ci ## Build and test all languages needed for CI
	docker run --rm \
		polygott-ci:latest \
		env LANGS=python3,ruby,java \
		bash -c polygott-self-test

test-%: stamps/image-% ## Build and test single language LANG
	docker run --rm \
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

.PHONY: clean
clean:
	rm -rf stamps
