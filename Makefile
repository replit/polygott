DUMMY: image

languages: import/index.js
	node ./import/index.js


image: Dockerfile languages/*.toml
	docker build -t polygott:latest .
