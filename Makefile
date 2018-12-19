.PHONY: DUMMY image languages deploy

DUMMY: image

languages: import/index.js
	node ./import/index.js


image: Dockerfile languages/*.toml
	docker build -t polygott:latest .

deploy: image
	docker tag polygott:latest gcr.io/marine-cycle-160323/polygott-base:latest
	docker push gcr.io/marine-cycle-160323/polygott-base:latest

