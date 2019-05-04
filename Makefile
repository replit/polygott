.PHONY: DUMMY image languages deploy

DUMMY: image

languages: import/index.js
	node ./import/index.js


image: Dockerfile languages/*.toml ## Make polygott image
	docker build -t polygott:latest .

deploy: image ## Send the image to GCS (repl.it use)
	docker tag polygott:latest gcr.io/marine-cycle-160323/polygott-base:latest
	docker push gcr.io/marine-cycle-160323/polygott-base:latest

test-%: ## Build and test only the langauge <arg>
	docker build -t polygott-$(*) --build-arg LANGS=$(*) .
	docker run polygott-$(*) bash -c polygott-self-test

test: image ## Build and test all langauges
	docker run polygott:latest bash -c polygott-self-test

help: ## show this message
	@echo "available targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | \
		fgrep -v fgrep | \
		sed 's/:.\+#. /|/g' | \
		sed 's/%/<arg>/g' | \
		column -s '|' -t
