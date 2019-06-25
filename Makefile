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

.PHONY: help
help: ## Show this message
	@echo "usage:" >&2
	@grep -h "[#]# " $(MAKEFILE_LIST) | \
		sed 's/^/  make /'       | \
		sed 's/:[^#]*[#]# /|/'   | \
		sed 's/%/LANG/'          | \
		column -t -s'|' >&2
