# Note that the '##' syntax is important, since it is parsed by the
# 'make help' target below.

# These are the most expensive languages to build.
ALL_LANGS=$(patsubst languages/%.toml,%,$(wildcard languages/*))
EXPENSIVE_LANGS=ballerina c clojure elisp enzyme flow forth gatsbyjs go haxe haskell kotlin java jest julia lua nim nextjs nodejs objective-c ocaml python python3 pygame pyxel quil raku rlang reactjs reactts react_native ruby rust scala swift tcl tools

# Default task:
.PHONY: image
image: build/stamps/image ## Build Docker image with all languages
	# Invoking the underlying build rule for image (if needed).

build/stamps/:
	mkdir -p "$@"

out/Dockerfile out/Dockerfile.splice out/languages.d out/languages.json: build/stamps/out
	# Invoking the underlying build rule for building out/ (if needed).

build/stamps/out: packages.txt $(wildcard gen/*) $(wildcard languages/*.toml) | build/stamps/
	rm -rf out/ && mkdir out
	(cd gen && npm install) && node gen/index.js
	touch "$@"

include out/languages.d

build/:
	mkdir -p "$@"

build/context.tar.bz2: build/stamps/out $(wildcard run_dir/*) $(wildcard extra/*) | build/
	./extra/manifest_tool.py context > "$@.tmp"
	mv "$@.tmp" "$@"
	sha256sum "$@"

build/stamps/image: extra/manifest_tool.py build/stamps/diffs
	./extra/manifest_tool.py splice $(ALL_LANGS) | docker buildx build \
		--progress=plain \
		-t polygott:latest \
		--load \
		-
	touch "$@"

.PHONY: image-ci
image-ci: build/stamps/image-ci ## Build Docker image with all languages needed for CI
	# Invoking the underlying build rule for image-ci (if needed).

build/stamps/image-ci: extra/manifest_tool.py build/diffs/phase2-tools.tar.bz2 build/diffs/phase2-java.tar.bz2 build/diffs/phase2-python3.tar.bz2 build/diffs/phase2-ruby.tar.bz2 build/diffs/phase2-nix.tar.bz2 | build/stamps/
	./extra/manifest_tool.py splice java python3 ruby nix | docker buildx build \
		--progress=plain \
		-t polygott-ci:latest \
		--load \
		-
	touch "$@"

# Rules to build partial layers. All of these have explicit dependencies so
# that `make -j` can do the right thing and avoid duplicate work.
.PRECIOUS: build/stamps/build-layer-%

build/stamps/build-layer-phase0: build/context.tar.bz2 extra/build-prybar-lang.sh | build/stamps/
	docker buildx build \
		--progress=plain \
		--cache-from="docker.io/replco/polygott-cache:phase0" \
		--cache-to="type=inline,mode=max" \
		--target="polygott-phase0" \
		--tag="polygott:phase0" \
		--load \
		- < build/context.tar.bz2
	touch "$@"

build/stamps/build-layer-phase1.0: build/context.tar.bz2 build/stamps/build-layer-phase0
	docker buildx build \
		--progress=plain \
		--cache-from="docker.io/replco/polygott-cache:phase1.0" \
		--cache-to="type=inline,mode=max" \
		--target="polygott-phase1.0" \
		--tag="polygott:phase1.0" \
		--load \
		- < build/context.tar.bz2
	touch "$@"

build/stamps/build-layer-phase1.5: build/context.tar.bz2 build/stamps/build-layer-phase1.0
	docker buildx build \
		--progress=plain \
		--cache-from="docker.io/replco/polygott-cache:phase1.5" \
		--cache-to="type=inline,mode=max" \
		--target="polygott-phase1.5" \
		--tag="polygott:phase1.5" \
		--load \
		- < build/context.tar.bz2
	touch "$@"

build/stamps/build-layer-%: build/context.tar.bz2 build/stamps/build-layer-phase1.5
	docker buildx build \
		--progress=plain \
		--cache-from="docker.io/replco/polygott-cache:$(*)" \
		--cache-to="type=inline,mode=max" \
		--target="polygott-$(*)" \
		--tag="polygott:$(*)" \
		--load \
		- < build/context.tar.bz2
	touch "$@"

build-layer-%: build/stamps/build-layer-% ## Build an intermediate Docker layer for language LANG
	# Invoking the underlying build rule for $(*) (if needed).

.PHONY: build-layers
build-layers: build-layer-phase0 build-layer-phase1.0 build-layer-phase1.5 build-layer-phase2-tools $(foreach lang,$(ALL_LANGS),build-layer-phase2-$(lang)) ## Build a cache image for all the most expensive languages.

build/manifests/:
	mkdir -p "$@"

build/manifests/%.json.gz: build/stamps/build-layer-% extra/manifest_tool.py | build/manifests/
	docker run --rm \
		--mount "type=bind,src=$(PWD)/extra/manifest_tool.py,target=/usr/bin/manifest_tool.py" \
		"polygott:$(*)" \
		/usr/bin/manifest_tool.py create | gzip --stdout > "$@.tmp"
	mv "$@.tmp" "$@"

.PHONY: build-manifests
build-manifests: build/manifests/phase1.5.json.gz build/manifests/phase2-tools.json.gz $(foreach lang,$(ALL_LANGS),build/manifests/phase2-$(lang).json.gz) ## Build all the manifests for each layer.

# Rule that pushes the intermediate cache files to DockerHub.
.PRECIOUS: build/stamps/push-cache-image-%
build/stamps/push-cache-image-%: build/stamps/build-layer-%
	docker image tag "polygott:$(*)" "replco/polygott-cache:$(*)"
	docker push "replco/polygott-cache:$(*)"
	touch "$@"

push-cache-image-%: build/stamps/push-cache-image-%
	# Invoking the underlying build rule for push-cache-image-$(*) (if needed).

.PHONY: push-cache-image
push-cache-image: push-cache-image-phase0 push-cache-image-phase1.0 push-cache-image-phase1.5 $(foreach lang,$(EXPENSIVE_LANGS),push-cache-image-phase2-$(lang))  ## Simultaneously build and push the cache image for all the most expensive languages.

build/stamps/diffs: build/diffs/phase2-tools.tar.bz2 $(foreach lang,$(ALL_LANGS),build/diffs/phase2-$(lang).tar.bz2) | build/stamps/
	touch "$@"

build/diffs/:
	mkdir -p "$@"

image-%: build/stamps/image-% ## Build Docker image with single language LANG
	# Invoking the underlying build rule for image-$(*) (if needed).

build/stamps/image-%: extra/manifest_tool.py build/diffs/phase2-tools.tar.bz2 build/diffs/phase2-%.tar.bz2 | build/stamps/
	./extra/manifest_tool.py splice $(*) | docker buildx build \
		--progress=plain \
		-t "polygott-$(*):latest" \
		--load \
		-
	touch "$@"

.PHONY: run
run: build/stamps/image ## Build and run image with all languages
	docker run -it --rm \
		polygott

run-%: build/stamps/image-% ## Build and run image with single language LANG
	docker run -it --rm \
		"polygott-$(*)"

.PHONY: test
test: build/stamps/image ## Build and test all languages
	docker run --rm \
		polygott:latest \
		bash -c polygott-self-test

.PHONY: test-ci
test-ci: build/stamps/image-ci ## Build and test all languages needed for CI
	docker run --rm \
		polygott-ci:latest \
		env LANGS=python3,ruby,java,nix \
		bash -c polygott-self-test

test-%: build/stamps/image-% ## Build and test single language LANG
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
	rm -rf build
