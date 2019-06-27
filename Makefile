# Note that the '##' syntax is important, since it is parsed by the
# 'make help' target below.

# Default task:
.PHONY: image
image: ## Build Docker image with all languages
	docker build -t polygott:latest .

image-%: ## Build Docker image with single language LANG
	docker build -t polygott-$(*) --build-arg LANGS=$(*) .

.PHONY: run
run: image ## Build and run image with all languages
	docker run -it --rm polygott

run-%: image-% ## Build and run image with single language LANG
	docker run -it --rm polygott-$(*)

.PHONY: test
test: image ## Build and test all languages
	docker run polygott:latest bash -c polygott-self-test

test-%: image-% ## Build and test single language LANG
	docker run polygott-$(*) bash -c polygott-self-test

# Build and test only changed/added languages.
# You should still do `make test` to have confidence everything works together.
# This is a way to catch some failures faster.
.PHONY: changed-test
changed-test: $(addprefix test-,$(basename $(notdir $(shell git diff --name-only origin/master -- languages))))

.PHONY: deploy
deploy: image ## Build and deploy image to Google Cloud Storage (repl.it use)
	docker tag polygott:latest gcr.io/marine-cycle-160323/polygott-base:latest
	docker push gcr.io/marine-cycle-160323/polygott-base:latest

.PHONY: help
help: ## Show this message
	@echo "usage:" >&2
	@grep -h "[#]# " $(MAKEFILE_LIST) | \
		sed 's/^/  make /'       | \
		sed 's/:[^#]*[#]# /|/'   | \
		sed 's/%/LANG/'          | \
		column -t -s'|' >&2
